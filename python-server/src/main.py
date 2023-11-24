from contextlib import asynccontextmanager
from faker import Faker
from pydantic import BaseModel, Field
from sqlalchemy import Column, CursorResult, Integer, String, Table, insert, select, MetaData, text
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from fastapi import Depends, FastAPI

engine = create_async_engine("mysql+aiomysql://root@localhost/pythonrust")
AsyncSessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=engine)
metadata = MetaData()

items = Table(
    "items",
    metadata,
     Column("id", Integer, primary_key=True, index=True),
     Column("title", String(20), nullable=False),
     Column("description", String(100), nullable=False),
     Column("price", Integer, nullable=False),
)

class Item(BaseModel):
    id: int = Field(alias="id")
    title: str = Field(alias="title")
    description: str = Field(alias="description")
    price: int  = Field(alias="price")


# Dependency
async def get_session():
    db = AsyncSessionLocal()
    try:
        yield db
    finally:
        await db.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        # await conn.run_sync(metadata.drop_all)
        await conn.run_sync(metadata.create_all)
    yield
    await engine.dispose()


app = FastAPI(lifespan=lifespan)


@app.get("/item/list")
async def api_item_list(start: int, session: AsyncSessionLocal = Depends(get_session)) -> list[Item]:
    cursor = await session.execute(
        select(items)
        .where(items.c.id <= start)
        .order_by(items.c.id.desc())
        .limit(10)
    )
    return cursor.fetchall()


@app.post("/item")
async def api_item_create(session: AsyncSessionLocal = Depends(get_session)):
    faker = Faker()
    num = 0
    for i in range(100000):
        cursor = await session.execute(
            insert(items).values(
                title=faker.text()[:15], description=faker.text()[:80], price=faker.random_digit_above_two() * 1000,
                
            )
        )
        num += cursor.rowcount
    await session.commit()
    return {"result": num}



