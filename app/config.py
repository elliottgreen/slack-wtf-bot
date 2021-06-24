import os
from pathlib import Path
from dotenv import load_dotenv

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)


class Config(object):
    @property
    def SLACK_TOKEN(self):
        #slack_tokens_string = getenv('SLACK_TOKENS')
        slack_tokens_string = os.environ.get('SLACK_TOKEN')
        if not slack_tokens_string:
            raise ValueError("No SLACK_TOKEN environment variable set")
        return [token.strip() for token in slack_tokens_string.split(',')]

    @property
    def DATA_URL(self):
        #data_url = getenv('DATA_URL')
        data_url = os.environ.get('DATA_URL')
        if not data_url:
            raise ValueError("No DATA_URL environment variable set")
        return data_url
