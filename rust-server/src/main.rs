use axum::{
    extract::{Query, State},
    routing::get,
    Json, Router,
};
use sqlx::{mysql::MySqlPoolOptions, MySql, Pool};
use std::{collections::HashMap, sync::Arc};

struct AppState {
    db: Pool<MySql>,
}

#[tokio::main]
async fn main() {
    let db = MySqlPoolOptions::new()
        .max_connections(5)
        .connect("mysql://root@localhost/pythonrust")
        .await
        .unwrap();
    let shared_state = Arc::new(AppState { db });

    let app = Router::new()
        .route("/item/list", get(get_item_list))
        .with_state(shared_state);

    axum::Server::bind(&"0.0.0.0:8000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn get_item_list(
    Query(params): Query<HashMap<String, String>>,
    State(state): State<Arc<AppState>>,
) -> Json<GetItemListResBody> {
    let items = sqlx::query_as!(
        Item,
        r#"SELECT * FROM items WHERE id <= ? LIMIT 10;"#,
        params.get("start")
    )
    .fetch_all(&state.db)
    .await
    .unwrap();
    Json(GetItemListResBody { items })
}

#[derive(serde::Serialize, sqlx::FromRow)]
#[serde(rename_all = "camelCase")]
struct Item {
    id: i64,
    title: String,
    description: String,
    price: i32,
}

#[derive(serde::Serialize)]
struct GetItemListResBody {
    items: Vec<Item>,
}
