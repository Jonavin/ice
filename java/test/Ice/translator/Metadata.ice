module MetadataTest
{
    sequence<int> IntSeq;
    ["java:type:java.util.LinkedList"] sequence<int> IntList;
    ["java:type:java.util.LinkedList"] sequence<IntSeq> IntSeqList;

    sequence<Object> ObjectSeq;
    ["java:type:java.util.LinkedList"] sequence<Object> ObjectList;
    ["java:type:java.util.LinkedList"] sequence<ObjectSeq> ObjectSeqList;

    dictionary<string, string> StringDict;
    ["java:type:java.util.HashMap"] dictionary<string, string> StringMap;

    class C
    {
        IntSeq intSeqMember;
        IntList intListMember;
        ["java:type:java.util.ArrayList"] IntSeq modifiedIntSeqMember;
        ["java:type:Test.CustomList"] IntList modifiedIntListMember;

        ObjectSeq objectSeqMember;
        ObjectList objectListMember;
        ["java:type:java.util.ArrayList"] ObjectSeq modifiedObjectSeqMember;
        ["java:type:Test.CustomList"] ObjectList modifiedObjectListMember;

	StringDict stringDictMember;
	StringMap stringMapMember;

        IntSeq opIntSeq(IntSeq inArg, out IntSeq outArg);
        IntList opIntList(IntList inArg, out IntList outArg);

        ObjectSeq opObjectSeq(ObjectSeq inArg, out ObjectSeq outArg);
        ObjectList opObjectList(ObjectList inArg, out ObjectList outArg);

        StringDict opStringDict(StringDict inArg, out StringDict outArg);
        StringMap opStringMap(StringMap inArg, out StringMap outArg);

        ["ami"] IntSeq opIntSeqAMI(IntSeq inArg, out IntSeq outArg);
        ["ami"] IntList opIntListAMI(IntList inArg, out IntList outArg);

        ["ami"] ObjectSeq opObjectSeqAMI(ObjectSeq inArg, out ObjectSeq outArg);
        ["ami"] ObjectList opObjectListAMI(ObjectList inArg, out ObjectList outArg);

        ["ami"] StringDict opStringDictAMI(StringDict inArg, out StringDict outArg);
        ["ami"] StringMap opStringMapAMI(StringMap inArg, out StringMap outArg);

        ["amd"] IntSeq opIntSeqAMD(IntSeq inArg, out IntSeq outArg);
        ["amd"] IntList opIntListAMD(IntList inArg, out IntList outArg);

        ["amd"] ObjectSeq opObjectSeqAMD(ObjectSeq inArg, out ObjectSeq outArg);
        ["amd"] ObjectList opObjectListAMD(ObjectList inArg, out ObjectList outArg);

        ["amd"] StringDict opStringDictAMD(StringDict inArg, out StringDict outArg);
        ["amd"] StringMap opStringMapAMD(StringMap inArg, out StringMap outArg);

        ["java:type:java.util.LinkedList"] IntSeq
        opIntSeq2(["java:type:java.util.ArrayList"] IntSeq inArg,
                  out ["java:type:Test.CustomList"] IntSeq outArg);

        ["java:type:java.util.ArrayList"] IntList
        opIntList2(["java:type:java.util.ArrayList"] IntList inArg,
                   out ["java:type:Test.CustomList"] IntList outArg);

        ["java:type:java.util.LinkedList"] ObjectSeq
        opObjectSeq2(["java:type:java.util.ArrayList"] ObjectSeq inArg,
                     out ["java:type:Test.CustomList"] ObjectSeq outArg);

        ["java:type:java.util.ArrayList"] ObjectList
        opObjectList2(["java:type:java.util.ArrayList"] ObjectList inArg,
                      out ["java:type:Test.CustomList"] ObjectList outArg);

        ["ami", "java:type:java.util.LinkedList"] IntSeq
        opIntSeq2AMI(["java:type:java.util.ArrayList"] IntSeq inArg,
                     out ["java:type:Test.CustomList"] IntSeq outArg);

        ["ami", "java:type:java.util.ArrayList"] IntList
        opIntList2AMI(["java:type:java.util.ArrayList"] IntList inArg,
                      out ["java:type:Test.CustomList"] IntList outArg);

        ["ami", "java:type:java.util.LinkedList"] ObjectSeq
        opObjectSeq2AMI(["java:type:java.util.ArrayList"] ObjectSeq inArg,
                        out ["java:type:Test.CustomList"] ObjectSeq outArg);

        ["ami", "java:type:java.util.ArrayList"] ObjectList
        opObjectList2AMI(["java:type:java.util.ArrayList"] ObjectList inArg,
                         out ["java:type:Test.CustomList"] ObjectList outArg);

        ["amd", "java:type:java.util.LinkedList"] IntSeq
        opIntSeq2AMD(["java:type:java.util.ArrayList"] IntSeq inArg,
                     out ["java:type:Test.CustomList"] IntSeq outArg);

        ["amd", "java:type:java.util.ArrayList"] IntList
        opIntList2AMD(["java:type:java.util.ArrayList"] IntList inArg,
                      out ["java:type:Test.CustomList"] IntList outArg);

        ["amd", "java:type:java.util.LinkedList"] ObjectSeq
        opObjectSeq2AMD(["java:type:java.util.ArrayList"] ObjectSeq inArg,
                     out ["java:type:Test.CustomList"] ObjectSeq outArg);

        ["amd", "java:type:java.util.ArrayList"] ObjectList
        opObjectList2AMD(["java:type:java.util.ArrayList"] ObjectList inArg,
                      out ["java:type:Test.CustomList"] ObjectList outArg);
    };
};
