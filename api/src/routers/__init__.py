# api/src/endpoints/__init__.py
from fastapi import APIRouter
from .habits import router as habits_router
from .members import router as members_router
from .moods import router as moods_router
from .quests import router as quests_router
from .tasks import router as tasks_router
from .health import router as health_router

router = APIRouter(
    prefix="/members",
)
router.include_router(habits_router)
router.include_router(members_router)
router.include_router(moods_router)
router.include_router(quests_router)
router.include_router(tasks_router)
router.include_router(health_router)