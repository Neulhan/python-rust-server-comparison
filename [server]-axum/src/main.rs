#[macro_use]
extern crate dotenv_codegen;

use axum::{
    extract::{Query, State},
    routing::get,
    Json, Router,
};
use sqlx::{mysql::MySqlPoolOptions, MySql, Pool};
use std::{collections::HashMap, sync::Arc};

struct AppState {
    my: Pool<MySql>,
    // pg Pool<Postgresql>
}

#[tokio::main]
async fn main() {
    let my = MySqlPoolOptions::new()
        .max_connections(5)
        .connect(dotenv!("DATABASE_URL"))
        .await
        .unwrap();
    // let pg = MySqlPoolOptions::new()
    //     .max_connections(5)
    //     .connect("mysql://root@localhost/pythonrust")
    //     .await
    //     .unwrap();
    // let shared_state = Arc::new(AppState { my, pg });
    let shared_state = Arc::new(AppState { my });

    let app = Router::new()
        .route("/item/list/mysql", get(get_item_list_mysql))
        // .route("/item/list/postgresql", get(get_item_list_postgresql))
        .with_state(shared_state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn get_item_list_mysql(
    Query(params): Query<HashMap<String, String>>,
    State(state): State<Arc<AppState>>,
) -> Json<GetItemListResBody> {
    let items = sqlx::query_as!(
        Item,
        r#"SELECT * FROM items WHERE id <= ? LIMIT 10;"#,
        params.get("start")
    )
    .fetch_all(&state.my)
    .await
    .unwrap();
    Json(GetItemListResBody { items })
}

// async fn get_item_list_postgresql(
//     Query(params): Query<HashMap<String, String>>,
//     State(state): State<Arc<AppState>>,
// ) -> Json<GetItemListResBody> {
//     let items = sqlx::query_as!(
//         Item,
//         r#"SELECT * FROM items WHERE id <= ? LIMIT 10;"#,
//         params.get("start")
//     )
//     .fetch_all(&state.pg)
//     .await
//     .unwrap();
//     Json(GetItemListResBody { items })
// }

#[derive(serde::Serialize, sqlx::FromRow)]
#[serde(rename_all = "camelCase")]
struct Item {
    id: Option<i32>,
    title: Option<String>,
    description: Option<String>,
    price: Option<i32>,
}

#[derive(serde::Serialize)]
struct GetItemListResBody {
    items: Vec<Item>,
}
