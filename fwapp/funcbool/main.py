from copy import deepcopy

def bool_proc(inp: list, conf: list, filt) -> list:
    out = []
    temp = {}
    for i, j in enumerate(inp):
        if filt(j, conf['rem']):
            continue

        for k, l in temp.items():
            if filt(j, l):
                out[k].append(i)
                break
        else:
            out.append([i])
            for k in conf['or']:
                if filt(j, k):
                    if i in temp:
                        temp[i] |= k
                    else:
                        temp[i] = deepcopy(k)
    return out