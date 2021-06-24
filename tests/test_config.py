import os
import pytest
from config import Config
from pathlib import Path
from dotenv import load_dotenv


env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)


@pytest.fixture(autouse=True)
def preserve_env_vars():
    orig_data_url = os.environ.get('DATA_URL')
    orig_slack_tokens = os.environ.get('SLACK_TOKEN')
    yield
    os.environ['DATA_URL'] = orig_data_url
    os.environ['SLACK_TOKEN'] = orig_slack_tokens


@pytest.mark.parametrize("setting", ['DATA_URL', 'SLACK_TOKEN'])
def test_raises_exception_on_missing_setting(setting):
    del os.environ[setting]
    with pytest.raises(ValueError) as e:
        assert Config().__getattribute__(setting)
    assert str(e.value) == f'No {setting} environment variable set'


def test_handles_multiple_tokens_comma_separated():
    os.environ['SLACK_TOKEN'] = 'token1,token2,token3'
    assert Config().SLACK_TOKEN == ['token1', 'token2', 'token3']
