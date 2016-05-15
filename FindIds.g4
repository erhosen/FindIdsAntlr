grammar FindIds;

@header {
    import java.util.HashMap;
    import java.util.ArrayList;
    import java.util.Arrays;
    import org.antlr.v4.runtime.Token;
}

@members {
    public static HashMap<String, ArrayList<Integer>> knownIdsMap;
    static {
        knownIdsMap = new HashMap<String, ArrayList<Integer>>();
        ArrayList<Integer> f = new ArrayList(Arrays.asList(0, 1, 2, 3));
        knownIdsMap.put("f", f);
    }

    public static String lineCharPos(Token token) {
        return " [Line: " + token.getLine() + ", Position: " + token.getCharPositionInLine() + "]";
    }

    public static void knownIdOutput(Token idTok, int arity) {
    	System.out.println("ASDASDASDASDASDASDASDASDASDASDASDS");
        String id = idTok.getText();
        if ( knownIdsMap.get(id).contains(arity) ){
            System.out.println("Found id " + id + " satisfied arity " + arity + lineCharPos(idTok));
        } else {
            System.out.println(
                "ERROR wrong number of arguments for id " + id +  " (found " + arity + 
                ", can be " + knownIdsMap.get(id) + ")" + lineCharPos(idTok)
            );
        }
    }

    public static void unknownIdOutput(Token idTok) {
        System.out.println("ERROR <unknown_id>: " + idTok.getText() + lineCharPos(idTok));
    }

    public static void undefUnknownIdOutput(Token idTok) {
        System.out.println("ERROR undefine <unknown_id>: " + idTok.getText() + lineCharPos(idTok));
    }

    public static void debugInfo() {
        System.out.println("######## knownIdsMap="+ knownIdsMap);
    }
}

prog: text*
    {
        debugInfo();
    };

//text: define | undef | butId | apply ;
text: butId | butId apply;

//define: DEFINE declaration;

//undef: UNDEF id=arg
  //  {
    //    if (knownIdsMap.containsKey($id.text)) {
      //  	knownIdsMap.remove($id.text);
        //} else {
          //  undefUnknownIdOutput($id.start);
        //}
//    };

//declaration: id=unknownId OPEN defArgs=defineArgs CLOSE val=value
  //  {
    //    ArrayList<Integer> l = new ArrayList<Integer>();
      //  for (int i=0; i<$defArgs.arity; i++){ l.add(i); }
        //knownIdsMap.put($id.text, l);
    //};

//defineArgs returns [int arity=0]: id=arg? 
  //  {
    //    if ( $id.text != null) { $arity++; }
    //} ( COMMA arg { $arity++; } )*;

//value: INT;

//arg: IDENTIFIER;

butId: OPEN | COMMA | CLOSE | INT | id=unknownId
    {
        unknownIdOutput($id.start);
    };

apply: id=knownId OPEN balArgs=balancedArgs CLOSE 
    { 
        knownIdOutput($id.start, $balArgs.arity); 
    };

balancedArgs returns [int arity=0]: balArg=balancedArg? 
    {
        if ( $balArg.text != null) { $arity++; }
    } ( COMMA balancedArg {$arity++;} )*;

balancedArg: INT | apply;

knownId: {knownIdsMap.containsKey($id)}? id=IDENTIFIER | unknownId;
unknownId: {!knownIdsMap.containsKey($id)}? id=IDENTIFIER;


IDENTIFIER : [a-zA-Z]+ ;
//DEFINE : '#define' ;
//UNDEF : '#undef' ;
INT : [-+]?[0-9]+ ;
WS : [ \t\r\n]+ -> skip ;

UNKNOWNID : [a-zA-Z]+ ;
OPEN : '(' ;
CLOSE : ')' ;
COMMA : [,] ;


//text: butId
//    | butId apply text;
//
//butId: OPEN | COMMA | CLOSE | unknownId;
//
//apply locals [int arity=-1] : id=knownId ( {$arity=0;} | OPEN balArgs=balancedArgs CLOSE {$arity=$balArgs.arity;} )
//       {ourIdentMap[$id.Text] == arity}? ;
//
//balancedArgs returns [int arity]: {$arity = 0;} balancedArg (COMMA balancedArg {$arity++;} )*;
//
//balancedArg:
//       | unknownId balancedArg
//       | OPEN balancedArgs CLOSE;
//
//knownId: id=IDENTIFIER {ourIdentMap.Contains($id)}?;
//unknownId: id=IDENTIFIER {!ourIdentMap.Contains($id)}?;