from django.shortcuts import render

# Create your views here.

def toolview(request):
    return render(request, 'tools/ydtools.html')

# tdee计算器
def tdeeview(request):
    return render(request, 'tools/tdee.html')

# 最大肌力计算
def oneRmview(request):
    return render(request, 'tools/1rm.html')

# 热量消耗计算器
def calview(request):
    return render(request, 'tools/cal.html')

# MACRO宏量营养计算器
def macroview(request):
    return render(request, 'tools/MACRO.html')

# MHR心跳计算器
def mhrview(request):
    return render(request, 'tools/MHR.html')

# 酒精热量计算
def alcoholview(request):
    return render(request, 'tools/alcohol.html')
