import logging

from fastapi import FastAPI

app = FastAPI()


@app.post("/echo")
async def echo(body: dict):
    logging.warning(body)
    return body
