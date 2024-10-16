# api/src/endpoints/__init__.py
from fastapi import APIRouter
from .root import router as root_router
from .habits import router as habits_router
from .members import router as members_router
from .moods import router as moods_router
from .quests import router as quests_router
from .tasks import router as tasks_router

router = APIRouter()
router.include_router(root_router)
router.include_router(habits_router, prefix="/habits")
router.include_router(members_router, prefix="/members")
router.include_router(moods_router, prefix="/moods")
router.include_router(quests_router, prefix="/quests")
router.include_router(tasks_router, prefix="/tasks")