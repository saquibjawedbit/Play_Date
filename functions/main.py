import firebase_admin
from firebase_admin import firestore
import numpy as np
from firebase_functions import https_fn
from datetime import datetime, timezone
from itertools import product
from google.cloud.firestore import CollectionReference
from google.cloud.firestore_v1.base_query import FieldFilter, BaseCompositeFilter
from firebase_admin import credentials, auth
import functions_framework
from time import sleep
import pytz

# Initialize the Firebase Admin SDK
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)


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

def get_answers(clg_name):
    #print("Starting....")
    males_answers = []
    females_answers = []
    
    male_map = []
    female_map = []
    
    # Get current UTC time
    utc_now = datetime.now(pytz.utc)

    # Convert to desired timezone (e.g., 'America/New_York')
    desired_timezone = pytz.timezone('Asia/Kolkata')
    local_time = utc_now.astimezone(desired_timezone)

    
    my_dt = datetime(local_time.year, local_time.month, local_time.day, 00, 00, 00)
    
    id = f"{my_dt.year}y{my_dt.month}m{my_dt.day}"
    
    main_docs = db.collection('contest').document(id)
    
    subcollection_ref = main_docs.collection('player')
    query = subcollection_ref.where('gender', '==', 'male').where('address', '==', clg_name)
    nested_docs = query.stream()

    index = 0
    for nested_doc in nested_docs:
        nested_doc_data = nested_doc.to_dict()
        # print(f"Fetched nested document data: {nested_doc_data}")
        males_answers.append([])
        
        round1 = nested_doc_data['round1']
        round2 = nested_doc_data['round2']
        round3 = nested_doc_data['round3']
            
        males_answers[index].append(round1)
        if(len(round2) == 4): males_answers[index].append(round2)            
        if(len(round3) == 4): males_answers[index].append(round3)
                
        #print(f"Received {nested_doc_data['id']}")
        male_map.append(nested_doc_data['id'])
        index += 1
            
        
            
    query = subcollection_ref.where('gender', '==', 'female').where('address', '==', clg_name)
    nested_docs = query.stream()
    index = 0
    for nested_doc in nested_docs:
        nested_doc_data = nested_doc.to_dict()
        # print(f"Fetched nested document data: {nested_doc_data}")
        females_answers.append([])
        round1 = nested_doc_data['round1']
        round2 = nested_doc_data['round2']
        round3 = nested_doc_data['round3']
            
        females_answers[index].append(round1)
        if(len(round2) == 4): females_answers[index].append(round2)            
        if(len(round3) == 4): females_answers[index].append(round3)
            
        female_map.append(nested_doc_data['id'])
        index += 1



    res = match_users(len(male_map), len(female_map), male_answers=males_answers, female_answers=females_answers)


    result = []
    if(res != -1):
        for i in range(0, len(male_map)):
            female_ref = female_map[res[i]]
            male_ref = male_map[i]
            result.append({
            'maleUserId': male_ref,
            'femaleUserId': female_ref,
            'point': len(male_map) - i + 1
            })

    doc_ref = db.collection("contest").document(id).collection("player").document(clg_name)
    doc_ref.set({
        "matches" : result
    })

    
    return "Matched"


def match_users(num_males, num_females, male_answers, female_answers):
    if(num_males == 0 or num_females == 0):
        return -1;

    males = range(num_males)
    females = range(num_females)
    
    # Calculate compatibility scores
    compatibility_scores = {}
    for male, female in product(males, females):
        compatibility_scores[(male, female)] = calculate_compatibility_score(male_answers[male], female_answers[female])
    
    # Get stable matches
    matches = stable_matching(males, females, compatibility_scores)
    
    return matches



@functions_framework.http
def list_users(request):
    # Fetch the list of users
    try:
        request_data = request.get_json()
        clg_name = request_data['university']
        print("Starting...")
        for i in range(3):
            # if(i == 0):
            #     sleep(127)
            # else:
            #     sleep(120)
            
            print(f"{clg_name} starting round {i}")
            result = get_answers(clg_name)
        return {'data' : "Matched"}, 200  
    except Exception as e:
        print(f"Error fetching user data: {e}")
        return {'error': str(e)}, 500
