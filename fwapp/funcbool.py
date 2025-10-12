from copy import deepcopy


def bool_proc(inp: list, conf: dict, filt) -> list:
    out = []
    temp = {}
    for i, j in enumerate(inp):
        if 'rem' in conf and filt(j, conf['rem']):
            continue

        for k, l in temp.items():
            if filt(j, l):
                out[k].append(i)
                break
        else:
            out.append([i])
            if 'or' in conf:
                for k in conf['or']:
                    if filt(j, k):
                        if i in temp:
                            temp[i] |= k
                        else:
                            temp[i] = deepcopy(k)
    return out


def fb_filt(x, y: list) -> bool:
    for i in y:
        if x['displayname'][-len(i):] == i:
            return True
    return False