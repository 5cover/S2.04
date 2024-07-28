import re

re_real='-?(\d+)\.(\d+)'

def scale(val):
    s=str(val)
    return len(re.match(re_real, s).group(1)) if val else 0

def precision(val):
    s=str(val)
    return len(re.match(re_real, s).group(0)) if val else 0

def strlen(val):
    return len(str(val))