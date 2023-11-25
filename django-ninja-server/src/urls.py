from django.contrib import admin
from django.urls import path
from ninja import NinjaAPI
from asgiref.sync import sync_to_async

from items.models import Item
from items.schema import ItemListResSchema, ItemSchema

api = NinjaAPI()


@api.get("/item/list")
async def api_item_list(request, start: int) -> ItemListResSchema:
    items = await sync_to_async(list)(Item.objects.filter(id__lte=start).order_by("-id")[:10])
    return {"items": items}


urlpatterns = [
    path("admin/", admin.site.urls),
    path("", api.urls),
]