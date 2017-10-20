Attribute VB_Name = "Module1"
Sub hluvukani_b()
'
' hluvukani_b Macro
' prep of form B
'

'
    Workbooks.Open Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_B_Registrar_Pessoas.xlsx"
    Range("Table_0[[#Headers],[metasubmissiondate]]").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.Copy
    Workbooks.Add
    ActiveSheet.Paste
    Cells.Select
    Cells.EntireColumn.AutoFit
    Range("A:A,B:B").Select
    Range("Table_0[[#Headers],[start]]").Activate
    Range("A:A,B:B,AD1,AD:AD").Select
    Range("Table_0[[#Headers],[end]]").Activate
    Application.CutCopyMode = False
    Selection.NumberFormat = "dd/mm/yyyy hh:mm"
    Columns("F:F").Select
    ActiveWindow.SmallScroll ToRight:=9
    Range("F:F,R:R").Select
    Range("Table_0[[#Headers],[pessoanasc]]").Activate
    Range("F:F,R:R,W:W,X:X").Select
    Range("Table_0[[#Headers],[docval]]").Activate
    Selection.NumberFormat = "dd/mm/yyyy"
    ActiveWorkbook.SaveAs Filename:= _
        "Y:\projects\illovo\dbupdate\Hluvukani_B_Registrar_Pessoas.csv", FileFormat:= _
        xlCSV, CreateBackup:=False
    ActiveWindow.Close
    ActiveWindow.Close
End Sub

