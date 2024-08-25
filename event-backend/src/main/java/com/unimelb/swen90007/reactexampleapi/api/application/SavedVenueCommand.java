package com.unimelb.swen90007.reactexampleapi.api.application;

import com.unimelb.swen90007.reactexampleapi.api.application.AppSessionManager;
import com.unimelb.swen90007.reactexampleapi.api.application.BusinessTransactionCommand;
import com.unimelb.swen90007.reactexampleapi.api.domain.VenueLogic;
import com.unimelb.swen90007.reactexampleapi.api.mappers.MapperRegistry;
import com.unimelb.swen90007.reactexampleapi.api.objects.PKCounts.Key;
import com.unimelb.swen90007.reactexampleapi.api.objects.Venue;
import com.unimelb.swen90007.reactexampleapi.api.util.DBUtil;
import com.unimelb.swen90007.reactexampleapi.api.util.ReadWriteLockManager;
import com.unimelb.swen90007.reactexampleapi.api.util.UnitOfWork;

import java.sql.SQLException;
import java.util.UUID;

public class SavedVenueCommand extends BusinessTransactionCommand {
    @Override
    public void process() throws Exception {
//        UnitOfWork.newCurrent();
        try {
            continueBusinessTransaction();
//        Venue venue = (Venue) getReq().getSession().getAttribute("venue");
//        String id = getReq().getParameter("id");
//        venue.setPrimaryKey(new Key(UUID.fromString(id)));
//        Mapper customerMapper = MapperRegistry.INSTANCE.getMapper(Customer.class);
//        MapperRegistry.getInstance().getMapper(Venue.class).update(venue);
            Venue venue = VenueLogic.updateVenue(getReq());
            System.out.println("-----test release lock command " + venue);
//            MapperRegistry.getInstance().getMapper(Venue.class).update(venue);
//            ReadWriteLockManager.getInstance().releaseWriteLock(venue.getId().toString());
            DBUtil.getConnection().commit();
//            getReq().getSession().setAttribute("newVenue", venue);
//        forward("/customerSaved.jsp");
//            UnitOfWork.getCurrent().commit();
        }catch (SQLException e){
            DBUtil.getConnection().rollback();
            throw e;
        }finally {
            DBUtil.closeConnection();
        }
    }
}
