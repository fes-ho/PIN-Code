from services import get_session

def insert_test_member():
    session_generator = get_session()
    session = next(session_generator)

    try:
        member = Member(
            username="test", 
            password="test", 
            email="test@example.com")

        session.add(member)
        session.commit()
    finally:
        session.close()
        