from locust import HttpUser, task


class WebsiteUser(HttpUser):
    @task
    def list(self):
        self.client.get("/item/list?start=10000")
