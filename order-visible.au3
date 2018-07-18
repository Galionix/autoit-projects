#include <IE.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#Include <Array.au3>


;Shady
;_IENavigate($oIE, "www.google.ru") ; Тоже не работает
;$oIE = _IECreate ($URL, 0, 0)




$sFileName = @ScriptDir & "\work.txt"
$sFileRead = FileRead($sFileName)




$oURL=''
$oName=''
$oCity=''

$oPhone=''


; Проверяет, является ли файл открытым, перед тем как использовать функции чтения/записи в файл
If $sFileName = -1 Then
    MsgBox(4096, "Ошибка", "Невозможно открыть файл @ScriptDir & \work.txt")
    Exit
EndIf

$oURL=FileReadLine($sFileName, 1)
$oName=FileReadLine($sFileName, 2)
$oPhone=FileReadLine($sFileName, 3)
$oCity=FileReadLine($sFileName, 4)


$sNeedIndex=FileReadLine($sFileName, 5)
FileClose($sFileName)
Global $sIndex=''

If $sNeedIndex=="0" Then

$sIndex=StringLeft ( $oCity,6)


EndIf

Func _IETagClassClick($o_Obj, $s_TagName, $s_ClassName, $s_Innertext = '')
    Local $o_Tags
    If Not IsObj($o_Obj) Then Return SetError(1)
    If (Not $s_TagName Or Not $s_ClassName) Then Return SetError(1)
    $o_Tags = _IETagNameGetCollection($o_Obj, $s_TagName)
    If @error Then Return SetError(1)
    For $o_Tag In $o_Tags
        If $o_Tag.ClassName == $s_ClassName Then
            If $s_Innertext Then
                If $o_Tag.innertext == $s_Innertext Then
                    _IEAction($o_Tag, 'click')
                    If @error Then Return SetError(1)
                    _IELoadWait($o_Obj)
                    If @error Then Return SetError(1)
                    Return SetError(0)
                EndIf
            Else
                _IEAction($o_Tag, 'click')
                If @error Then Return SetError(1)
                _IELoadWait($o_Obj)
                If @error Then Return SetError(1)
                Return SetError(0)
            EndIf
        EndIf
    Next
    Return SetError(2)
 EndFunc   ;==>_IETagClassClick

If $sNeedIndex=="1" Then


$oIE = _IECreate('https://dadata.ru/clean/#process-person')
$HWND = _IEPropertyGet($oIE, "hwnd")
WinSetState($HWND, "", @SW_MAXIMIZE)
_IEAction($oIE, "visible")
_IELoadWait($oIE)
$oAddr = _IEGetObjById($oIE, 'id_address')
_IEFormElementSetValue($oAddr, $oCity)

_IETagClassClick($oIE, 'button', 'button red', 'Проверить')

_IELoadWait($oIE)

$sHTML=_IEPropertyGet($oIE,"outertext")




$aIndex=StringRegExp($sHTML,"\n[0-9]{6}\s",2)



 If $oCity=='' Then
   $oCity='Лос-Анджелес'
   $aIndex[0]='000000'
   EndIf

$sIndex=_ArrayToString($aIndex)
_IEQuit ($oIE)


EndIf


;MsgBox($MB_SYSTEMMODAL, "Title", $sIndex, 10)





$oIE = _IECreate('http://svparfum.ru/magazin?mode=cart&action=cleanup')
$HWND = _IEPropertyGet($oIE, "hwnd")
WinSetState($HWND, "", @SW_MAXIMIZE)
_IEAction($oIE, "visible")


_IELoadWait($oIE)
_IENavigate($oIE, $oURL)
_IELoadWait($oIE)
$sClassName='shop-btn buy shop-buy-btn'
$sTagName='button'


   Local $oTags
    $oTags = _IETagNameGetCollection($oIE, $sTagName)
    For $oTag In $oTags
        If $oTag.className = $sClassName Then
            _IEAction($oTag, 'click')
            ExitLoop
        EndIf
    Next
    _IELoadWait($oIE)


_IELinkClickByText ($oIE, "Оформить заказ")
_IELoadWait($oIE)
_IENavigate($oIE, 'http://svparfum.ru/magazin?mode=order')
_IELoadWait($oIE)


$oInd = _IEGetObjByName($oIE, '1171606[0]')

_IEFormElementSetValue($oInd, $sIndex)

$oCit = _IEGetObjByName($oIE, '1171606[1]')

_IEFormElementSetValue($oCit, $oCity)

_IETagClassClick($oIE, 'button', 'shop2-btn', 'Оформить заказ')
_IELoadWait($oIE)

$oFF = _IEGetObjByName($oIE, 'fio')

_IEFormElementSetValue($oFF, $oName)

$oPh = _IEGetObjByName($oIE, 'phone')

_IEFormElementSetValue($oPh, $oPhone)

$oMail = _IEGetObjByName($oIE, 'email')

_IEFormElementSetValue($oMail, 'dimas-bot@ya.ru')


$oCheckBox = _IEGetObjByName($oIE, "personal_data")

$oCheckBox.checked = True

;_IETagClassClick($oIE, 'button', 'shop2-btn', 'Оформить заказ')
_IELoadWait($oIE)

_IEQuit ($oIE)

FileDelete ( $sFileName )
FileOpen(@ScriptDir & "\done.txt", 1)




