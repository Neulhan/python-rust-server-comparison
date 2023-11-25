# Python Rust Server Comparison

## [Common]
|||  
|---|---|  
|database|mysql|
|cloud|aws-ec2 |
|server instance|t3.micro|

#### *t3.micro 
|cpu|기준선|memory|cost/hour|
|---|---|---|---|
|2vCPU|10%|1GiB Memory|0.0104 USD|

## [python]
|||  
|---|---|  
|python|3.11.6|
|http server|fastapi 0.104.1|  
|database|sqlalchemy 2.0.23|
|asgi server|uvicorn 0.24.0|
|serializer|pydantic 2.5.2|

## [rust]
|||  
|---|---| 
|rustc|1.74.0|
|http server|axum 0.6.20|  
|database|sqlx 0.7.3|
|serializer|serde 1.0|
|async runtime|tokio 1.34|

## [loadtest]
locust 


```python
uvicorn src.main:app --reload
```
