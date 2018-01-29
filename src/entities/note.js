"use strict";

const Entity = require('./entity');

class Note extends Entity {
    async getAttributes() {
        return this.sql.getEntities("SELECT * FROM attributes WHERE noteId = ?", [this.noteId]);
    }

    async getAttribute(name) {
        return this.sql.getEntity("SELECT * FROM attributes WHERE noteId = ? AND name = ?", [this.noteId, name]);
    }

    async getRevisions() {
        return this.sql.getEntities("SELECT * FROM note_revisions WHERE noteId = ?", [this.noteId]);
    }

    async getTrees() {
        return this.sql.getEntities("SELECT * FROM note_tree WHERE isDeleted = 0 AND noteId = ?", [this.noteId]);
    }
}

module.exports = Note;