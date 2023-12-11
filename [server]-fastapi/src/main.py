from contextlib import asynccontextmanager
from pydantic import BaseModel, Field
from sqlalchemy import Column, CursorResult, Integer, String, Table, insert, select, MetaData, text
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from fastapi import Depends, FastAPI


mysql_engine = create_async_engine("mysql+aiomysql://root@localhost/pythonrust")
MySQLAsyncSessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=mysql_engine)
# pg_engine = create_async_engine("mysql+aiomysql://root@localhost/pythonrust")
# PGAsyncSessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=pg_engine)
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


async def get_mysql_session():
    db = MySQLAsyncSessionLocal()
    try:
        yield db
    finally:
        await db.close()


# async def get_pg_session():
#     db = MySQLAsyncSessionLocal()
#     try:
#         yield db
#     finally:
#         await db.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    await mysql_engine.dispose()
    # await pg_engine.dispose()


app = FastAPI(lifespan=lifespan)


@app.get("/item/list/mysql")
async def api_item_list(start: int, session: MySQLAsyncSessionLocal = Depends(get_mysql_session)) -> list[Item]:
    cursor = await session.execute(
        select(items)
        .where(items.c.id <= start)
        .order_by(items.c.id.desc())
        .limit(10)
    )
    return cursor.fetchall()


# @app.get("/item/list/postgresql")
# async def api_item_list(start: int, session: PGAsyncSessionLocal = Depends(get_pg_session)) -> list[Item]:
#     cursor = await session.execute(
#         select(items)
#         .where(items.c.id <= start)
#         .order_by(items.c.id.desc())
#         .limit(10)
#     )
#     return cursor.fetchall()
