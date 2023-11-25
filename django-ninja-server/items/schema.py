from ninja import ModelSchema, Schema

from items.models import Item


class ItemSchema(ModelSchema):
    class Meta:
        model = Item
        fields = ['id', 'title', 'description', 'price']


class ItemListResSchema(Schema):
    items: list[ItemSchema]
    