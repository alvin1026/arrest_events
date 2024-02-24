from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class CrimeType(db.Model):
    __tablename__ = "crime_type"
    __table_args__ = {"schema": "public2"}

    id = Column(Integer, primary_key=True)
    name = Column(String)


class ArrestSubject(db.Model):
    __tablename__ = "arrest_subjects"
    __table_args__ = {"schema": "public2"}

    id = Column(Integer, primary_key=True)
    first_name = Column(String)
    last_name = Column(String)
    dob = Column(Date)
    gender = Column(String(1))
    race = Column(String)


class Organization(db.Model):
    __tablename__ = "organizations"
    __table_args__ = {"schema": "public2"}

    id = Column(Integer, primary_key=True)
    name = Column(String)


class Officer(db.Model):
    __tablename__ = "officers"
    __table_args__ = {"schema": "public2"}

    id = Column(Integer, primary_key=True)
    first_name = Column(String)
    last_name = Column(String)
    dob = Column(Date)
    gender = Column(String(1))
    employment_start_date = Column(Date)
    organization_id = Column(Integer, ForeignKey("organizations.id"))


class ArrestEvent(db.Model):
    __tablename__ = "arrest_events"
    __table_args__ = {"schema": "public2"}

    id = Column(Integer, primary_key=True)
    officer_id = Column(Integer, ForeignKey(Officer.id))
    subject_id = Column(Integer, ForeignKey(ArrestSubject.id))
    arrest_type_id = Column(Integer)
    arrested_at = Column(TIMESTAMP)
    crime_type_id = Column(Integer, ForeignKey(CrimeType.id))

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
