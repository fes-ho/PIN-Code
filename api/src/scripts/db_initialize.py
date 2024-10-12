from services import get_session
from models import Member

# The function returns a generator
session_generator = get_session()
# The generator is used to get the session
session = next(session_generator)

try:
    member = Member(name="John Doe", secret_name="John Wick", age=42)
    session.add(member)
    session.commit()
finally:
    session.close()