# api/src/endpoints/__init__.py
from fastapi import APIRouter
from .habits import router as habits_router
from .members import router as members_router
from .mood import router as moods_router
from .quests import router as quests_router
from .tasks import router as tasks_router
from .health import router as health_router
from .friendship import router as friendship_router
from .streaks import router as streaks_router

router = APIRouter()
router.include_router(health_router)
router.include_router(tasks_router)
router.include_router(streaks_router)
router.include_router(habits_router)

member_router = APIRouter(
    prefix="/members",
)
member_router.include_router(members_router)
member_router.include_router(moods_router)
member_router.include_router(quests_router)
member_router.include_router(friendship_router)