import functions_framework


@functions_framework.http
def handler(request):
    """Responds to an HTTP request using the Functions Framework.

    Args:
        request (flask.Request): The request object.
        <flask.palletsprojects.com>

    Returns:
        The response text or any set of values that can be turned into a
        Response object using `make_response`
        <flask.palletsprojects.com>.
    """
    return 'Hello World!'
