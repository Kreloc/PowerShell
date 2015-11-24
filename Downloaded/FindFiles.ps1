Function Find-Files
{
param(
   [string] $dirRoot = $pwd,
   [string] $Spec = "*.*",
   [bool] $longOnly = $false
   )

# Changes:
#  23/05/2008, Wayne Martin, Added the option to only report +max_path entries, and report the short path of those directories (which makes it easier to access them)
#
#
# Description:
#  Use the wide unicode versions to report a directory listing of all files, including those that exceed the MAX_PATH ANSI limitations
#
# Assumptions, this script works on the assumption that:
#  There's a console to write the output from the compiled VB.Net
#
# Author:
#  Wayne Martin, 15/05/2008
#
# Usage
#  PowerShell . .\FindFiles.ps1 -d c:\temp -s *.*
#
#  PowerShell . .\FindFiles.ps1 -d c:\temp
#
#  PowerShell . .\FindFiles.ps1 -d g: -l $true
#
# References:
#  http://msdn.microsoft.com/en-us/library/aa364418(VS.85).aspx
#  http://blogs.msdn.com/jaredpar/archive/2008/03/14/making-pinvoke-easy.aspx 

$provider = new-object Microsoft.VisualBasic.VBCodeProvider
$params = new-object System.CodeDom.Compiler.CompilerParameters
$params.GenerateInMemory = $True
$refs = "System.dll","Microsoft.VisualBasic.dll"
$params.ReferencedAssemblies.AddRange($refs)

$txtCode = @'
Imports System
Imports System.Runtime.InteropServices
Class FindFiles

Const ERROR_SUCCESS As Long = 0
Private Const MAX_PREFERRED_LENGTH As Long = -1

  _
Public Structure WIN32_FIND_DATAW
    '''DWORD->unsigned int
    Public dwFileAttributes As UInteger
    '''FILETIME->_FILETIME
    Public ftCreationTime As FILETIME
    '''FILETIME->_FILETIME
    Public ftLastAccessTime As FILETIME
    '''FILETIME->_FILETIME
    Public ftLastWriteTime As FILETIME
    '''DWORD->unsigned int
    Public nFileSizeHigh As UInteger
    '''DWORD->unsigned int
    Public nFileSizeLow As UInteger
    '''DWORD->unsigned int
    Public dwReserved0 As UInteger
    '''DWORD->unsigned int
    Public dwReserved1 As UInteger
    '''WCHAR[260]
      _
    Public cFileName As String
    '''WCHAR[14]
      _
    Public cAlternateFileName As String
End Structure

  _
Public Structure FILETIME
    '''DWORD->unsigned int
    Public dwLowDateTime As UInteger
    '''DWORD->unsigned int
    Public dwHighDateTime As UInteger
End Structure

Partial Public Class NativeMethods
   
    '''Return Type: HANDLE->void*
    '''lpFileName: LPCWSTR->WCHAR*
    '''lpFindFileData: LPWIN32_FIND_DATAW->_WIN32_FIND_DATAW*
      _
    Public Shared Function FindFirstFileW( ByVal lpFileName As String,  ByRef lpFindFileData As WIN32_FIND_DATAW) As System.IntPtr
    End Function
  
    '''Return Type: BOOL->int
    '''hFindFile: HANDLE->void*
    '''lpFindFileData: LPWIN32_FIND_DATAW->_WIN32_FIND_DATAW*
      _
    Public Shared Function FindNextFileW( ByVal hFindFile As System.IntPtr,  ByRef lpFindFileData As WIN32_FIND_DATAW) As  Boolean
    End Function

    '''Return Type: BOOL->int
    '''hFindFile: HANDLE->void*
      _
    Public Shared Function FindClose(ByVal hFindFile As System.IntPtr) As  Boolean
    End Function

    '''Return Type: DWORD->unsigned int
    '''lpszLongPath: LPCWSTR->WCHAR*
    '''lpszShortPath: LPWSTR->WCHAR*
    '''cchBuffer: DWORD->unsigned int
      _
    Public Shared Function GetShortPathNameW( ByVal lpszLongPath As String,  ByVal lpszShortPath As System.Text.StringBuilder, ByVal cchBuffer As UInteger) As UInteger
    End Function

End Class


Private Const FILE_ATTRIBUTE_DIRECTORY As Long = &H10
    Dim FFW as New NativeMethods

Function Main(ByVal dirRoot As String, ByVal sFileSpec As String, Byval longOnly As Boolean) As Long
    Dim result As Long

    result = FindFiles(dirRoot, sFileSpec, longOnly)

    main = result          ' Return the result
End Function

Function FindFiles(ByRef sDir As String, ByVal sFileSpec as String, Byval longOnly As Boolean) As Long
    Const MAX_PATH As Integer = 260
    Dim FindFileData as WIN32_FIND_DATAW
    Dim hFile As Long
    Dim sFullPath As String
    Dim sFullFile As String
    Dim length as UInteger
    Dim sShortPath As New System.Text.StringBuilder()


    sFullPath = "\\?\" & sDir

    'console.writeline(sFullPath & "\" & sFileSpec)

    hFile = FFW.FindFirstFileW(sFullPath & "\" & sFileSpec, FindFileData)     ' Find the first object
    if hFile > 0 Then            ' Has something been found?
      If (FindFileData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY)  <> FILE_ATTRIBUTE_DIRECTORY Then  ' Is this a file?
        sFullFile = sFullPath & "\" & FindFileData.cFileName
        If (longOnly AND sFullFile.Length >= MAX_PATH) Then
          length = FFW.GetShortPathNameW(sFullPath, sShortPath, sFullPath.Length) ' GEt the 8.3 path
          console.writeline(sFullFile & " " & sshortpath.ToString())  ' Yes, report the full path and filename
        ElseIf (NOT longOnly)
          console.writeline(sFullFile)
        End If
      End If

      While FFW.FindNextFileW(hFile, FindFileData)        ' For all the items in this directory
        If (FindFileData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY) <> FILE_ATTRIBUTE_DIRECTORY Then ' Is this a file?
          sFullFile = sFullPath & "\" & FindFileData.cFileName
          If (longOnly AND sFullFile.Length >= MAX_PATH) Then
            length = FFW.GetShortPathNameW(sFullPath, sShortPath, sFullPath.Length) ' GEt the 8.3 path
            console.writeline(sFullFile & " " & sshortpath.ToString())  ' Yes, report the full path and filename
          ElseIf (NOT longOnly)
            console.writeline(sFullFile)
          End If
        End If
      End While
      FFW.FindClose(hFile)           ' Close the handle
      FindFileData = Nothing
    End If

    hFile = FFW.FindFirstFileW(sFullPath & "\" & "*.*", FindFileData)      ' Repeat the process looking for sub-directories using *.*
    if hFile > 0 Then
      If (FindFileData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY) AND _
          (FindFileData.cFileName <> ".") AND (FindFileData.cFileName <> "..") Then
        Call FindFiles(sDir & "\" & FindFileData.cFileName, sFileSpec, longOnly)      ' Recurse
      End If

      While FFW.FindNextFileW(hFile, FindFileData)
        If (FindFileData.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY) AND _
            (FindFileData.cFileName <> ".") AND (FindFileData.cFileName <> "..") Then
          Call FindFiles(sDir & "\" & FindFileData.cFileName, sFileSpec, longOnly)     ' Recurse
        End If
      End While
      FFW.FindClose(hFile)           ' Close the handle
      FindFileData = Nothing
    End If

End Function

end class

'@


$cr = $provider.CompileAssemblyFromSource($params, $txtCode)
if ($cr.Errors.Count) {
    $codeLines = $txtCode.Split("`n");
    foreach ($ce in $cr.Errors)
    {
        write-host "Error: $($codeLines[$($ce.Line - 1)])"
        write-host $ce
        #$ce out-default
    }
    Throw "INVALID DATA: Errors encountered while compiling code"
 }
$mAssembly = $cr.CompiledAssembly
$instance = $mAssembly.CreateInstance("FindFiles")

$result = $instance.main($dirRoot, $Spec, $longOnly)
$result
}