public class HierarchicalSearchUtil {
  	public static final Integer DEFAULT_MAX_DEPTH = 5;
	public static String[] generateMaxTraverseFields(SObjectField relationship, Integer depth) {
    	Schema.DescribeFieldResult describe = relationship.getDescribe();
    	String rName = describe.getRelationshipName();
    	String cName = describe.getName();
		String[] relFields = new List<String>{};
    	for (Integer i = 0; i <= depth; i++) {
      		String[] nParts = new List<String>{};
      		for (Integer j = 0; j < i; j++) {
        		nParts.add(rName);
      		}
      	nParts.add(cName);
      	relFields.add(String.join(nParts, '.'));
    	}
    return relFields;
  	}
}