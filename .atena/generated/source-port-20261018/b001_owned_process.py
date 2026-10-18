import ctypes as c,ctypes.wintypes as w,sys,json
from pathlib import Path
sys.stdout.reconfigure(encoding='utf-8')
k=c.WinDLL('kernel32',use_last_error=True);nt=c.WinDLL('ntdll')
class PE(c.Structure):
 _fields_=[('dwSize',w.DWORD),('cntUsage',w.DWORD),('th32ProcessID',w.DWORD),('th32DefaultHeapID',c.c_size_t),('th32ModuleID',w.DWORD),('cntThreads',w.DWORD),('th32ParentProcessID',w.DWORD),('pcPriClassBase',w.LONG),('dwFlags',w.DWORD),('szExeFile',w.WCHAR*260)]
class US(c.Structure):_fields_=[('Length',w.USHORT),('MaximumLength',w.USHORT),('Buffer',c.c_void_p)]
k.CreateToolhelp32Snapshot.restype=w.HANDLE;k.OpenProcess.restype=w.HANDLE
k.OpenProcess.argtypes=[w.DWORD,w.BOOL,w.DWORD];k.CloseHandle.argtypes=[w.HANDLE]
k.Process32FirstW.argtypes=[w.HANDLE,c.POINTER(PE)];k.Process32NextW.argtypes=[w.HANDLE,c.POINTER(PE)]
nt.NtQueryInformationProcess.argtypes=[w.HANDLE,w.ULONG,c.c_void_p,w.ULONG,c.POINTER(w.ULONG)]
k.TerminateProcess.argtypes=[w.HANDLE,w.UINT]
snap=k.CreateToolhelp32Snapshot(2,0);entry=PE();entry.dwSize=c.sizeof(PE);ok=k.Process32FirstW(snap,c.byref(entry));matches=[]
expected=str((Path.cwd()/'tmp/port-b1/source').resolve()).lower()
while ok:
 if 'godot' in entry.szExeFile.lower():
  print('Godot PID',entry.th32ProcessID,'parent',entry.th32ParentProcessID,'name',entry.szExeFile)
  handle=k.OpenProcess(0x1000,False,entry.th32ProcessID)
  if handle:
   size=w.ULONG();nt.NtQueryInformationProcess(handle,60,None,0,c.byref(size))
   if 0<size.value<1000000:
    buf=c.create_string_buffer(size.value)
    status=nt.NtQueryInformationProcess(handle,60,buf,size.value,c.byref(size))
    if status==0:
     u=US.from_buffer(buf);cmd=c.wstring_at(u.Buffer,u.Length//2)
     if expected.replace('\\','/') in cmd.lower().replace('\\','/') and 'tools/mobile_buttons_check.tscn' in cmd:
      matches.append({'pid':entry.th32ProcessID,'parent':entry.th32ParentProcessID,'command':cmd})
   print('query status',status if size.value else 'no size', 'last error',c.get_last_error())
   k.CloseHandle(handle)
  else:print('OpenProcess error',c.get_last_error())
 ok=k.Process32NextW(snap,c.byref(entry))
k.CloseHandle(snap)
print(json.dumps(matches,ensure_ascii=False,indent=2))
if '--stop' in sys.argv:
 for row in matches:
  handle=k.OpenProcess(1,False,row['pid']);assert handle
  assert k.TerminateProcess(handle,1);k.CloseHandle(handle)
 print('Stopped only matching owned synthetic mobile test processes.')
