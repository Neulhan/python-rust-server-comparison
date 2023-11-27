from django.db import models


class Item(models.Model):
    title = models.CharField(max_length=20, null=False)
    description = models.CharField(max_length=100, null=False)
    price = models.IntegerField(null=False)

    class Meta:
        db_table = "items"

    def __str__(self):
        return f"({self.id}) {self.title}"
