#-*- coding: UTF-8 -*-
import jieba.posseg as pseg
import codecs
import html2text
import math
import json
from goose import Goose
from goose.text import StopWordsChinese
import sys
import argparse


IgnoreWordsFeatureList = ['w', 'x', 'u', 'p', 'c' ,'q']


def getValueFromNotNilKey(key, dic):
    if dic.has_key(key):
        return dic[key]
    else:
        return None

def getIntValueFromNotNilKey(key, dic):
    value = getValueFromNotNilKey(key, dic)
    if value != None:
        return int(value)
    return 0

def subTopItemsIndictionary(dic ,length):
    wordMap = dic
    items = sorted(wordMap.items(), key = lambda wordMap:wordMap[1])
    i = 0
    ret = {}
    for item in reversed(items):
        if i >= length:
            break
        i = i + 1
        ret[item[0]] = item[1]
    return ret


def topItemsInDictionary(dic ,length):
    wordMap = dic
    items = sorted(wordMap.items(), key = lambda wordMap:wordMap[1])
    i = 0
    topKeys = []
    for item in reversed(items):
        if i >= length:
            break
        i = i + 1
        topKeys.append(item[0])
    return topKeys

def getWordsWeight(wordFeature):
    try:
        if len(wordFeature) < 1:
            return 0
        if wordFeature[0:1] in IgnoreWordsFeatureList:
            return 0
        return 1
    except:
        return 1



def extractWordCountModel(content):
    words = pseg.cut(content)
    sumCount = 0
    wordMap = {}
    for word in words:
        w = word.word
        if '\n' in w:
            w.replace('\n', '')
        if '\t' in w:
            w.replace('\t', '')
        if len(w.strip()) == 0:
            continue 
        sumCount += 1
        try:
            wordWeight = getWordsWeight(word.flag)
            if wordWeight == 0:
                continue
            if wordMap.has_key(w):
                count = wordMap[w]
                wordMap[w] = count + wordWeight
            else:
                wordMap[w] = wordWeight
            wordMap[w]
        except KeyError:
            continue
    return wordMap, sumCount
 

def ExtractWordModel(url):
    print(url)
    print("\n")
    g = Goose({'stopwords_class': StopWordsChinese})
    article = g.extract(url=url)
    content = article.cleaned_text
    wrodRatioMap = {}
    wordMap , sumCount = extractWordCountModel(content)
    if sumCount != 0:
        keys = wordMap.keys()
        for key in keys:
            try:
                count = wordMap[key]
                value = float(count)/sumCount
                wrodRatioMap[key] = float(count)/sumCount
            except KeyError:
                continue
    return subTopItemsIndictionary(wrodRatioMap, 1000)

parser = argparse.ArgumentParser()
parser.add_argument('-u', action = 'store', dest='url')
results = parser.parse_args()
words = ExtractWordModel(results.url)

tops = topItemsInDictionary(words, 100)
print(json.dumps(tops))
