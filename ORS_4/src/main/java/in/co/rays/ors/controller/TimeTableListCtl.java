package in.co.rays.ors.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import in.co.rays.ors.bean.BaseBean;
import in.co.rays.ors.bean.CourseBean;
import in.co.rays.ors.bean.SubjectBean;
import in.co.rays.ors.bean.TimeTableBean;
import in.co.rays.ors.model.CourseModel;
import in.co.rays.ors.model.SubjectModel;
import in.co.rays.ors.model.TimeTableModel;
import in.co.rays.ors.model.exception.ApplicationException;
import in.co.rays.ors.util.DataUtility;
import in.co.rays.ors.util.PropertyReader;
import in.co.rays.ors.util.ServletUtility;

@WebServlet(name = "TimeTableListCtl", urlPatterns = {"/ctl/TimeTableListCtl"})
public class TimeTableListCtl extends BaseCtl {

	private static Logger log = Logger.getLogger(TimeTableListCtl.class);

	protected void preload(HttpServletRequest request) {

		CourseModel model = new CourseModel();
		SubjectModel smodel = new SubjectModel();
		List<CourseBean> list = null;
		List<SubjectBean> list2 = null;
		try {
			list = model.list();
			list2 = smodel.list();
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("courseList", list);
		request.setAttribute("subjectList", list2);

	}

	protected BaseBean populateBean(HttpServletRequest request) {
		TimeTableBean bean = new TimeTableBean();

//		bean.setId(DataUtility.getLong(request.getParameter("id")));
		bean.setCourseId(DataUtility.getLong(request.getParameter("clist")));
		bean.setSubjectId(DataUtility.getInt(request.getParameter("slist")));
	//	bean.setSubjectName(DataUtility.getString(request.getParameter("slist")));
		bean.setExamDate(DataUtility.getDate(request.getParameter("Exdate")));
	//	System.out.println("populate bean==========>>>> " + bean.getExamDate());
		populateDTO(bean, request);
		return bean;
	}
    /**
     * Contains display logics
     */

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List list ;

		int pageNo = 1;
		int pageSize = DataUtility.getInt(PropertyReader.getValue("page.size"));

		TimeTableModel model = new TimeTableModel();
		TimeTableBean bean =(TimeTableBean) populateBean(request);

//		String op = DataUtility.getString(request.getParameter("operation"));
   //   String[] ids = request.getParameterValues("ids");
	    

		try {
			list = model.search(bean, pageNo, pageSize);
			ServletUtility.setBean(bean, request);
			
	//		ServletUtility.setList(list, request);
			if (list==null && list.size()==0) {
				ServletUtility.setErrorMessage("No record Found", request);
			}
			ServletUtility.setList(list, request);
			ServletUtility.setPageNo(pageNo, request);
			ServletUtility.setPageSize(pageSize, request);
			ServletUtility.forward(getView(), request, response);


		} catch (ApplicationException e) {
			e.printStackTrace();
			log.error(e);
			ServletUtility.handleException(e, request, response);
		}
	}
    /**
     * Contains Submit logics
     */

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List list;
		String op = DataUtility.getString(request.getParameter("operation"));

		int pageNo = DataUtility.getInt(request.getParameter("pageNo"));
		int pageSize = DataUtility.getInt(request.getParameter("pageSize"));
		pageNo = (pageNo == 0) ? 1 : pageNo;
		pageSize = (pageSize == 0) ? DataUtility.getInt(PropertyReader.getValue("page.size")) : pageSize;


		TimeTableBean bean = (TimeTableBean) populateBean(request);	
		TimeTableModel model = new TimeTableModel();
		String[] ids = (String[]) request.getParameterValues("ids");
				
			        if (OP_SEARCH.equalsIgnoreCase(op)) {
				    pageNo = 1;
					} else if (OP_NEXT.equalsIgnoreCase(op)) {
						pageNo++;	
					} else if (OP_PREVIOUS.equalsIgnoreCase(op)) {
						if(pageNo<1){
							pageNo--;
						}else{
							pageNo= 1;
						}	
					}
					else if (OP_NEW.equalsIgnoreCase(op)) 
					{
						ServletUtility.redirect(ORSView.TIMETABLE_CTL, request, response);
						return ;
					}
					
					else if (OP_RESET.equalsIgnoreCase(op)) {
						ServletUtility.redirect(ORSView.TIMETABLE_LIST_CTL, request, response);
						return;
					}
					else if (OP_DELETE.equalsIgnoreCase(op)) {
						pageNo=1;
						if (ids != null && ids.length > 0) {
							TimeTableBean bean3 = new TimeTableBean();

							for (String id2 : ids) {
								int id1 = DataUtility.getInt(id2);
								bean3.setId(id1);
								try {
									model.delete(bean3);
								} catch (ApplicationException e) {
									e.printStackTrace();
									ServletUtility.handleException(e, request, response);
									return;
								}
								ServletUtility.setSuccessMessage("Data Deleted Succesfully", request);
							}
						
						}else{
							ServletUtility.setErrorMessage("Select at least one Record", request);
						}
					}
			    	try {
						list = model.search(bean, pageNo, pageSize);
						ServletUtility.setBean(bean, request);
					}
					catch(ApplicationException e){	
						ServletUtility.handleException(e, request, response);
						return;
					}
			   if(list==null || list.size()==0 && !OP_DELETE.equalsIgnoreCase(op)) 
			{
				ServletUtility.setErrorMessage("No Record Found", request);
			}
			ServletUtility.setBean(bean, request);
			ServletUtility.setList(list, request);
			ServletUtility.setPageNo(pageNo, request);
			ServletUtility.setPageSize(pageSize, request);
	        ServletUtility.forward(getView(), request, response);			
		}

	@Override
	protected String getView() {
		return ORSView.TIMETABLE_LIST_VIEW;
	}

}
