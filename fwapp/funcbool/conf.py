config = {
    'or': [{'Case', 'Other Types Personal Pronoun'}],
    'rem': {'Archaic'}
}

def filt(x, y: set) -> bool:
    for i in y:
        if x['displayname'][-len(i):] == i:
            return True
    return False