import firebase_admin
from firebase_admin import firestore
from firebase_functions import scheduler_fn, options
import numpy as np
from firebase_functions import https_fn
from datetime import datetime, timezone
from itertools import product
from google.cloud.firestore import CollectionReference
from google.cloud.firestore_v1.base_query import FieldFilter, BaseCompositeFilter




firebase_admin.initialize_app()

db = firestore.client()



# Calculate compatibility score between two users
def calculate_compatibility_score(male_answers, female_answers):
    return np.sum(np.abs(np.array(male_answers) - np.array(female_answers)))

# Gale-Shapley Algorithm for Stable Matching
def stable_matching(males, females, compatibility_scores):
    n = len(males)
    free_males = list(males)
    proposals = {m: [] for m in males}
    current_partner = {f: None for f in females}
    
    while free_males:
        male = free_males.pop(0)
        for female in sorted(females, key=lambda f: compatibility_scores[(male, f)]):
            if female not in proposals[male]:
                proposals[male].append(female)
                if current_partner[female] is None:
                    current_partner[female] = male
                    break
                else:
                    current_male = current_partner[female]
                    if compatibility_scores[(male, female)] < compatibility_scores[(current_male, female)]:
                        current_partner[female] = male
                        free_males.append(current_male)
                        break
    return current_partner

@https_fn.on_request(
    cors=options.CorsOptions(
        cors_origins=[r"firebase\.com$", r"https://flutter\.com"],
        cors_methods=["get", "post"],
    )
)
def get_answers(req: https_fn.Request) -> https_fn.Response:
    print("Started")
    # conditions = [['startTime', '==', start_timestamp], ['gender', '==', 'M']]
    males_answers = []
    females_answers = []
    
    male_map = []
    female_map = []
    
    my_dt = datetime.now()
    my_dt = datetime(my_dt.year, my_dt.month, my_dt.day, 00, 00, 00)

    start_timestamp = my_dt.replace(tzinfo=timezone.utc).timestamp()
    main_collection_ref = db.collection('contest')#.where('startTime', '==', start_timestamp)
    main_docs = main_collection_ref.stream()
    
    for main_doc in main_docs:
        subcollection_ref = main_doc.reference.collection('player')
        query = subcollection_ref.where('gender', '==', 'M')
        nested_docs = query.stream()

        index = 0
        for nested_doc in nested_docs:
            nested_doc_data = nested_doc.to_dict()
            # print(f"Fetched nested document data: {nested_doc_data}")
            males_answers.append([])
            males_answers[index].append(nested_doc_data['round1'])
            males_answers[index].append(nested_doc_data['round2'])
            males_answers[index].append(nested_doc_data['round3'])
            male_map.append(nested_doc_data['userRef'])
            index += 1
            
        
            
        query = subcollection_ref.where('gender', '==', 'F')
        nested_docs = query.stream()
        index = 0
        for nested_doc in nested_docs:
            nested_doc_data = nested_doc.to_dict()
            # print(f"Fetched nested document data: {nested_doc_data}")
            females_answers.append([])
            females_answers[index].append(nested_doc_data['round1'])
            females_answers[index].append(nested_doc_data['round2'])
            females_answers[index].append(nested_doc_data['round3'])
            female_map.append(nested_doc_data['userRef'])
            index += 1

        res = match_users(len(male_map), len(female_map), male_answers=males_answers, female_answers=females_answers)
    
        for i in range(0, len(male_map)):
            female_ref = female_map[res[i]]
            male_ref = male_map[i]
            
            if male_ref:
                # Fetch the user document using the reference
                user_doc = male_ref.get()

                if user_doc.exists:
                    user_data = user_doc.to_dict()
                    user_name = user_data.get('name')
                    # Update the user document by adding a matched user to the 'matches' array field
                    male_ref.update({
                        'matches': firestore.ArrayUnion([{
                            'matchedUserId': female_ref,
                            'matchDate': datetime.now()
                        }])
                    })
                else:
                    print("User document does not exist")

            else:
                print("No user reference found in the document")

            if female_ref:
                # Fetch the user document using the reference
                user_doc = female_ref.get()

                if user_doc.exists:
                    user_data = user_doc.to_dict()
                    user_name = user_data.get('name')
                    female_ref.update({
                        'matches': firestore.ArrayUnion([{
                            'matchedUserId': male_ref,
                            'matchDate': datetime.now()
                        }])
                    })
                else:
                    print("User document does not exist")

            else:
                print("No user reference found in the document")
        

        

        
    return https_fn.Response("Matched")


def match_users(num_males, num_females, male_answers, female_answers):
    males = range(num_males)
    females = range(num_females)
    
    # Calculate compatibility scores
    compatibility_scores = {}
    for male, female in product(males, females):
        compatibility_scores[(male, female)] = calculate_compatibility_score(male_answers[male], female_answers[female])
    
    # Get stable matches
    matches = stable_matching(males, females, compatibility_scores)
    
    return matches


# # Schedule for 13:11
# @scheduler_fn.on_schedule(options.ScheduleOptions(schedule='11 13 * * *'))
# def scheduled_compatibility_calculation_1311(event):
#     pass


# # Schedule for 17:55
# @scheduler_fn.on_schedule(options.ScheduleOptions(schedule='55 17 * * *'))
# def scheduled_compatibility_calculation_1755(event):
#     pass


# # Schedule for 23:11
# @scheduler_fn.on_schedule(options.ScheduleOptions(schedule='11 23 * * *'))
# def scheduled_compatibility_calculation_2311(event):
#     pass


