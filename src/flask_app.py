from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError

from domain.model import ArrestEvent, db
from config import get_postgres_uri

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = get_postgres_uri()
db.init_app(app)


@app.route("/arrest_events", methods=["GET"])
def get_arrest_events():
    try:
        arrest_events = ArrestEvent.query.all()
        return jsonify({"data": [event.as_dict() for event in arrest_events]})
    except SQLAlchemyError as e:
        return jsonify({"error": str(e)}), 500


@app.route("/arrest_events/<int:event_id>", methods=["GET"])
def get_arrest_event(event_id):
    try:
        arrest_event = ArrestEvent.query.get(event_id)
        if arrest_event:
            return jsonify({"data": arrest_event.as_dict()})
        else:
            return jsonify({"error": "Event not found"}), 404
    except SQLAlchemyError as e:
        return jsonify({"error": str(e)}), 500


@app.route("/arrest_events", methods=["POST"])
def create_arrest_event():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    try:
        new_event = ArrestEvent(
            officer_id=data["officer_id"],
            subject_id=data["subject_id"],
            arrest_type_id=data["arrest_type_id"],
            arrested_at=data.get("arrested_at"),
            crime_type_id=data["crime_type_id"],
        )
        db.session.add(new_event)
        db.session.commit()
        return (
            jsonify({"message": "Event created successfully", "id": new_event.id}),
            201,
        )
    except SQLAlchemyError as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


@app.route("/arrest_events/<int:event_id>", methods=["PUT"])
def update_arrest_event(event_id):
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data provided"}), 400

    try:
        arrest_event = ArrestEvent.query.get(event_id)
        if not arrest_event:
            return jsonify({"error": "Event not found"}), 404

        for key, value in data.items():
            if hasattr(arrest_event, key):
                setattr(arrest_event, key, value)

        db.session.commit()
        return jsonify({"message": "Event updated successfully"}), 200
    except SQLAlchemyError as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


@app.route("/arrest_events/<int:event_id>", methods=["DELETE"])
def delete_arrest_event(event_id):
    try:
        arrest_event = ArrestEvent.query.get(event_id)
        if not arrest_event:
            return jsonify({"error": "Event not found"}), 404

        db.session.delete(arrest_event)
        db.session.commit()
        return jsonify({"message": "Event deleted successfully"}), 200
    except SQLAlchemyError as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run("0.0.0.0", port=5100, debug=True)
