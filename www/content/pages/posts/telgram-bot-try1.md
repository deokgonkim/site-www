---
# Title of your post. If not set, filename will be used.
title: "telegram bot 테스트 노트"
date: 2017-08-24T15:09:00+09:00
draft: false

# Set weigth to 1 to mark this post as sticky post.
weight: 10

# List of authors of the post.
authors:
  - dgkim

# Tags for this post.
tags:
  - "Open Source"

# Set how many table of contents levels to be showed on page.
geekblogToC: 3

# Add an anchor link to headlines.
geekblogAnchor: true
---

얼마전, telegram 공개 채널을 한번 만들어 보았다.

<a href="https://t.me/okkykr">https://t.me/okkykr</a>

그리고, bot을 다시 한번 테스트 해볼까 시동을 걸었다.

시작은.. 검색 'telegram python bot'

https://github.com/python-telegram-bot/python-telegram-bot

git clone 받고, git submodule update 하고, ...

... 두둥 ...

```python
ImportError: No module named future.backports.urllib
```

음, ... pip install을 피하고자 했는데, ...
음, ... future란 것도 모듈이네, 이런 건 설치해보자.

https://pypi.python.org/pypi/future/0.16.0
다운로드 받고, setup.py install 사용해서 설치함.

다시한번

```python
>>> import telegram
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "telegram/__init__.py", line 94, in <module>
    from .bot import Bot
  File "telegram/bot.py", line 34, in <module>
    from telegram.utils.request import Request
  File "telegram/utils/request.py", line 31, in <module>
    import certifi
ImportError: No module named certifi
```

... 두둥 ...

certifi란 것도 필요하구나.
https://pypi.python.org/pypi/certifi/2017.7.27.1
그런데, ... .whl 음.. 느낌이 안 좋다.

pip를 설치하자.
https://stackoverflow.com/questions/17271319/how-do-i-install-pip-on-macos-or-os-x

다음. pip install certifi

다시한번

```
>>> import telegram
>>> 
```

되는 것 같다.

... 잠시 추가로 테스트 ...
( bot을 만드는 것도, telegram은 웹 관리자 화면 같은 걸 통하지 않고 봇에게 말을 걸어서 만든다. ... 만들었다. )

... 1분 후, ...

```python
>>> import telegram
>>> bot = telegram.Bot(token='nnnnnn:alphanumber')
>>> bot.get_me()
<telegram.user.User object at 0x10x10x10x>
>>> 
```

된다.

... 10분 후, ...
봇에게 말을 걸어보고, 봇이 응답하게 해보았다.

```python
>>> updates = bot.get_updates()
>>> updates
[]
>>> updates = bot.get_updates()
>>> updates
[<telegram.update.Update object at 0x10x10x10x>, <telegram.update.Update object at 0x10x10x10x>]
>>> chat_id = bot.get_updates()[-1].message.chat_id
>>> chat_id
1x60x39x2
>>> bot.send_message(chat_id=chat_id, text="I'm a bot")
<telegram.message.Message object at 0x10x10x10x>
```

다음 단계, bot 을 채널에 초대해보자.

https://stackoverflow.com/questions/42674340/how-to-join-my-telegram-bot-to-public-channel
https://stackoverflow.com/questions/33126743/how-do-i-join-my-bot-to-the-channel

관리자가 관리자로 추가할 수 있군.

... 8분 후, ...

```python
>>> bot.send_message(chat_id='@dgkimnet', text='hi')
<telegram.message.Message object at 0x10x10x10x>
```

올, 된다. 지금 만든 것은, 말하기 전용? 이지만. 되긴 된다. 듣고 반응하는 것도 가능하겠지만. 지금 하기에는 dgkim이 너무 나태하다.

ps. 워드프레스에서 코드 활용할 때, lt, gt 넣는 것 참 번거롭네.
