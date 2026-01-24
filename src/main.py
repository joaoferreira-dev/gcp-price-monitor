import functions_framework
import requests
from typing import Dict, Any
from time import time

from bs4 import BeautifulSoup
from firebase_admin import firestore, initialize_app, get_app
from google.cloud import logging


logging_client = logging.Client()
logger = logging_client.logger("gcp-price-monitor")

@functions_framework.http
def handler(request) -> Dict[str, Any]:
    """Responds to an HTTP request using the Functions Framework.

    Args:
        request (flask.Request): The request object.

    Returns:
        Dict[str, Any]: {statusCode: int, details: str}.
    """
    try:
        data = request.get_json(silent=True) or {}
        url = data.get('url')
        if not url:
            logger.error('There is no URL in the event.')
            return {'statusCode': 400, 'details': 'URL missing in Event'}

        headers = {'User-Agent': 'Mozilla/5.0'}
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'html.parser')
        span = soup.find('span', {'data-qa-id': 'symbol-last-value'})
        if not span:
            logger.error('BTCUSD price span not found!')
            return {'statusCode': 500, 'details': 'BTCUSD price not found'}
        btcusd_price = span.text.strip()
        logger.info(f'BTCUSD price found: {btcusd_price}')

        # Initialize Firestore client
        try:
            get_app()
        except ValueError:
            initialize_app()

        db = firestore.client()

        doc_ref = db.collection('prices').document('BTCUSD')
        doc_ref.set({
            'price': btcusd_price,
            'source': url,
            'timestamp': str(int(time()))
        })
        logger.info('Price successfully saved to Firestore.')
        return {'statusCode': 200, 'details': 'OK', 'price': btcusd_price}
    except Exception as e:
        logger.error(f'Error processing request: {e}')
        return {'statusCode': 500, 'details': str(e)}
