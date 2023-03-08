public class RootSearch {
    SObjectType sobType;
  	SObjectField parentField;
  	String query;
  	Integer maxDepthForIteration;
  	public RootSearch(SObjectType sobType, SObjectField parentField) {
    	this(sobType, parentField, HierarchicalSearchUtil.DEFAULT_MAX_DEPTH);
  	}
	public RootSearch(SObjectType sobType, SObjectField parentField, Integer maxDepthForIteration) {
    	this.sobType = sobType;
        this.parentField = parentField;
    	this.maxDepthForIteration = maxDepthForIteration;
    	this.query = generateQuery();
  	}
	public Map<Id, Id> search(Set<Id> ids) {
    	Map<Id, Id> rootMap = new Map<Id, Id>();
    	List<SObject> sobs = Database.query(this.query);
		Map<Id, Id> searchDeeperIds = new Map<Id, Id>();
    	for (SObject sob : sobs) {
      		RootSearchResult root = findRoot(sob, 1, rootMap);
      		if (root.confirmed) {
        		rootMap.put(sob.Id, root.rootId);
      		} else {
        		searchDeeperIds.put(root.rootId, sob.Id);
      		}
    	}
    	if (searchDeeperIds.size() > 0) {
      		Map<Id, Id> deepRoots = search(searchDeeperIds.keySet());
      		for (Id intermediate : deepRoots.keySet()) {
        	rootMap.put(searchDeeperIds.get(intermediate), deepRoots.get(intermediate));
      		}
    	}
		return rootMap;
  	}
	private RootSearchResult findRoot(SObject sob, Integer depth, Map<Id, Id> foundRoots) {	
    	if (foundRoots.containsKey(sob.Id)) {
      		return new RootSearchResult(foundRoots.get(sob.Id), true);
    	}
		Boolean maxDepth = isMaxDepth(depth);
        SObject parent = sob.getSObject(this.parentField);
    	Boolean isParent = parent == null;
    	if (isParent || maxDepth) {
      		return new RootSearchResult(sob.Id, isParent);
    	} else {
      		return findRoot(parent, ++depth, foundRoots);
    	}
  	}
	private String generateQuery() {
    	String[] fields = HierarchicalSearchUtil.generateMaxTraverseFields(this.parentField, this.maxDepthForIteration);
    	return String.format(
      	'SELECT {0} \nFROM {1} \nWHERE Id IN :ids',
      	new List<String>{ String.join(fields, ',\n'), this.sobType.getDescribe().getName() }
    	);
  	}
	private Boolean isMaxDepth(Integer depth) {
    	return depth == this.maxDepthForIteration;
  	}
	private class RootSearchResult {
    	public Id rootId;
    	public Boolean confirmed;
    	public RootSearchResult(Id rootId, Boolean confirmed) {
      		this.rootId = rootId;
      		this.confirmed = confirmed;
    	}
  	}
}