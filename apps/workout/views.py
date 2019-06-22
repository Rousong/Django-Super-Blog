from django.shortcuts import render

# Create your views here.

def toolview(request):
    return render(request, 'tools/ydtools.html')

