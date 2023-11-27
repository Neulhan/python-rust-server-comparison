from django.urls import path
from ninja import NinjaAPI
from asgiref.sync import sync_to_async

from items.models import Item
from items.schema import ItemListResSchema

api = NinjaAPI()


@api.get("/item/list", response=ItemListResSchema)
async def api_item_list(request, start: int):
    items = await sync_to_async(list)(Item.objects.filter(id__lte=start).order_by("-id").all()[:10])
    return {"items": items}


urlpatterns = [
    path("", api.urls),
]