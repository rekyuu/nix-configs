#! /usr/bin/env python3

import json
import sys
import subprocess
import re
import os
import calendar

from datetime import date, timedelta
from typing import List

DATE_FORMAT="+%Y年 %m月 %d日 (%a) - %T"

ENV = os.environ
ENV["LC_TIME"] = "ja_JP.UTF-8";

# https://stackoverflow.com/a/49138114
def find_weekdays_between(start: date, end: date, weekday: int) -> List[date]:
    total_days: int = (end - start).days + 1
    all_days = [start + timedelta(days=day) for day in range(total_days)]
    return [day for day in all_days if day.weekday() is weekday]

# https://github.com/Alexays/Waybar/issues/2260#issuecomment-2189676335
def sh(*args: str) -> str:
	return subprocess.run(args, capture_output=True, check=True, encoding="utf-8", env=ENV).stdout.strip()

def get_tooltip() -> str:
    today = date.today()
    cache_file = f"/tmp/waybar-clock-cal_{today.strftime("%Y%m%d")}.txt"

    if os.path.isfile(cache_file):
        with open(cache_file) as f:
            return f.read()

    cal = sh("cal", "--monday")

    # Fix weekday line
    weekdays = cal.split("\n")[1].split(" ")

    for weekday in weekdays:
        cal = re.sub(f'\\b{weekday}\\b', f' <span color="#e6cd69">{weekday}</span>  ', cal)

    # Color today's date
    cal = re.sub(f'\\b{today.day}\\b', f'<span background="#d6d6d6" color="#151718">{today.day}</span>', cal)

    # Color Weekends
    month_start: date = date(today.year, today.month, 1)
    month_end: date = date(today.year, today.month, calendar.monthrange(today.year, today.month)[1])
    saturdays = find_weekdays_between(month_start, month_end, 5)
    sundays = find_weekdays_between(month_start, month_end, 6)

    for day in saturdays:
        cal = re.sub(f'\\b{day.day}\\b', f'<span color="#55b5db">{day.day}</span>', cal)

    for day in sundays:
        cal = re.sub(f'\\b{day.day}\\b', f'<span color="#cd3f45">{day.day}</span>', cal)

    # Store to cache
    with open(cache_file, "w") as f:
        f.write(cal)

    return cal

d = {
	'text': sh("date", DATE_FORMAT),
	'tooltip': get_tooltip(),
}

json.dump(d, sys.stdout)