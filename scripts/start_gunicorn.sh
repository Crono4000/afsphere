
gunicorn --chdir "$AFSPHERE_PATH/python" -c "$AFSPHERE_PATH/python/gunicorn.conf.py"  flask_utils:app