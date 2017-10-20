Attribute VB_Name = "Module1"
Sub hluvukani_A_encontros_prep()
Attribute hluvukani_A_encontros_prep.VB_ProcData.VB_Invoke_Func = " \n14"
'
' hluvukani_A_encontros_prep Macro
'

'
    Sheets("Hluvukani_A_encontros_sensibili").Select
    Range("form_a_encontros_sensibilizacao[[#Headers],[geom]]").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Range("form_a_encontros_sensibilizacao[[#Headers],[geom]]").Select
    ActiveWorkbook.RefreshAll
    Sheets("Hluvukani_A_encontros_sensibili").Select
    Range(Selection, Cells(1)).Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Columns("A:A").EntireColumn.AutoFit
    Columns("C:C").EntireColumn.AutoFit
    Columns("B:B").EntireColumn.AutoFit
    Cells.Select
    Cells.EntireColumn.AutoFit
    Range("B:B,C:C").Select
    Range("form_a_encontros_sensibilizacao[[#Headers],[start]]").Activate
    Range("B:B,C:C,AB:AB").Select
    Range("form_a_encontros_sensibilizacao[[#Headers],[end]]").Activate
    Application.CutCopyMode = False
    Selection.NumberFormat = "dd/mm/yyyy hh:mm"
    Columns("G:G").Select
    Selection.NumberFormat = "dd/mm/yyyy"
    Range("form_a_encontros_sensibilizacao[[#Headers],[geom]]").Select
    ChDir "Y:\projects\illovo\dbupdate"
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_A_encontros_sensibilizacao.csv", _
        FileFormat:=xlCSV, CreateBackup:=False
    ActiveWindow.Close
End Sub
