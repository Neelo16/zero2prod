use zero2prod::run;

#[tokio::main]
pub async fn main() -> std::io::Result<()> {
    let listener =
        std::net::TcpListener::bind("127.0.0.1:8080").expect("Failed to bind random port");
    run(listener)?.await
}
