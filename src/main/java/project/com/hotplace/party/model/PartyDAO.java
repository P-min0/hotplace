package project.com.hotplace.party.model;

import java.util.List;

public interface PartyDAO {

	public List<PartyVO> selectAll(String searchKey, String searchWord);
	
	public PartyVO selectOne(PartyVO vo);
	
	public List<PartyVO> searchList(String searchKey, String searchWord, int page);
	
	public int insert(PartyVO vo);
	
	public int update(PartyVO vo);
	
	public int delete(PartyVO vo);
	
	public void vCountUp(PartyVO vo);
	
//	public void deleteOverDate();

}