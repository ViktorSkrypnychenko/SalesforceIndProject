public class ChildrenSearch {
  	SObjectType sobType;
  	SObjectField relationship;
  	String query;
  	Integer maxDepthForIteration;
	public ChildrenSearch(SObjectType sobType, SObjectField relationship) {
    	this(sobType, relationship, HierarchicalSearchUtil.DEFAULT_MAX_DEPTH);
  	}
	public ChildrenSearch(SObjectType sobType, SObjectField relationship, Integer maxDepthForIteration) {
    	this.relationship = relationship;
    	this.sobType = sobType;
    	this.maxDepthForIteration = maxDepthForIteration;
    	query = generateQuery();
  	}
	public Map<Id, Id[]> search(Set<Id> parentIds) {
    	Map<Id, Id[]> trunkLeafMap = new Map<Id, Id[]>();
		Map<Id, TrunkReference> leafTrunkMap = new Map<Id, TrunkReference>();
    	for (Id pId : parentIds) {
      		leafTrunkMap.put(pId, new TrunkReference(pId, 0));
    	}
		Territory__c[] children = Database.query(query);
		Map<Id, Id> potentialLeafMap = new Map<Id, Id>();
    	for (SObject child : children) {	
      		TrunkReference tr = getTrunkReference(child, 1, leafTrunkMap);
      		Id trunkId = tr.trunkId;
			if (isDeepestDepth(tr.depth)) {
        		potentialLeafMap.put(child.Id, trunkId);
      		}
			leafTrunkMap.put(child.Id, tr);
			if (trunkLeafMap.containsKey(trunkId)) {
        		trunkLeafMap.get(trunkId).add(child.Id);
      		} else {
        		trunkLeafMap.put(trunkId, new List<Id>{ child.Id });
      		}
    	}
		if (potentialLeafMap.size() > 0) {
      		Set<Id> potentialLeafKeyset = potentialLeafMap.keySet();
      		Map<Id, Id[]> deepLeafs = search(potentialLeafKeyset);
      		for (Id potentialLeaf : potentialLeafKeyset) {
        		Id trunkId = potentialLeafMap.get(potentialLeaf);
        		if (deepLeafs.containsKey(potentialLeaf)) {
          			trunkLeafMap.get(trunkId).addAll(deepLeafs.get(potentialLeaf));
        		}
      		}
    	}
    	return trunkLeafMap;
  	}
	public TrunkReference getTrunkReference(SObject sob, Integer depth, Map<Id, TrunkReference> cachedLeafTrunks) {
    	Id parentId = (Id) sob.get(relationship);
    	TrunkReference td = cachedLeafTrunks.get(parentId);
    	if (td != null) {
      		return new TrunkReference(td.trunkId, td.depth + depth);
    	}
    	return getTrunkReference(sob.getSObject(relationship), ++depth, cachedLeafTrunks);
  	}
	private String generateQuery() {
    	String[] selectList = HierarchicalSearchUtil.generateMaxTraverseFields(this.relationship, this.maxDepthForIteration);
    	Integer fieldSize = selectList.size();
		String[] whereList = new List<String>{};
    	String[] orderList = new List<String>(fieldSize);
    	for (Integer i = 0; i < fieldSize; i++) {
      		String field = selectList[i];
      		whereList.add(field + ' IN :parentIds ');
      		orderList[fieldSize - 1 - i] = field + ' NULLS LAST';
    	}
		String sObjectName = sobType.getDescribe().getName();
		return String.format(
      		'SELECT {0} \n FROM {1} \n WHERE \n {2} \n ORDER BY {3}',
      		new List<String>{
        		String.join(selectList, ',\n'),
        		sObjectName,
        		String.join(whereList, '\nOR '),
        		String.join(orderList, ',\n')
      		}
    	);
  	}
	private Boolean isDeepestDepth(Integer depth) {
    	return depth > this.maxDepthForIteration;
  	}
	class TrunkReference {
    	Id trunkId;
    	Integer depth;
    	public TrunkReference(Id trunkId, Integer depth) {
      		this.trunkId = trunkId;
      		this.depth = depth;
    	}
  	}
}