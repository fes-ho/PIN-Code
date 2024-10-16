from services import get_session
from models import Member

def get_member_by_id(member_id: int):
    session_generator = get_session()
    session = next(session_generator)
    try :
        member = session.get(Member, member_id)
        return member
    finally:
        session.close()