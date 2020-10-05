import json
import requests
import sys

def main(argv):
    try:
        endpoint = sys.argv[1]
    except IndexError:
        raise SystemExit("Please provide a single argument for the API endpoint")

    # Try an initial GET request to the ready endpoint to check the service is available.
    r = requests.get(f'http://{endpoint}/ready')
    if r.status_code != 200:
        print("The service is not available or ready.  Confirm the deployment was successful and the endpoint is correct.")
        sys.exit()

    reasons = [
        'I can code.',
        'I can build and operate infrastructure.',
        'I can listen.',
        'I\'m passionate about software engineering and operations.',
        'If I don\'t know it I\'ll learn it',
        'I have a belief in functioning as a servant leader to the team.',
        'I don\'t ask people to do anything I wouldn\'t do myself',
        'I like to have fun'
    ]

    # Execute a series of POST request to generate some data in the database.
    for reason in reasons:
        payload = {'reason': reason}
        r = requests.post(f'http://{endpoint}/reason', data=json.dumps(payload))
        if r.status_code != 200:
            print("There was an issue executing a POST request.  Please confirm the deployment was successful")
            sys.exit()

    # Get the data from the service and print it in a user friendly fashion.
    r = requests.get(f'http://{endpoint}/reason')
    if r.status_code != 200:
            print("There was an issue executing a GET request.  Please confirm the deployment was successful")
            sys.exit()

    reasons = r.json()
    print('\nHere are some reasons why I would be a great fit for this role and you should hire me:\n')
    for reason in reasons:
        print(reasons[reason].get('reason'))
    print('\nThank you very much for taking the time to consider me for this role!\n')

if __name__ == "__main__":
    main(sys.argv)
