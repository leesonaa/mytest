"use strict";

const Expression = require('./expression');

class NotExp extends Expression {
    constructor(subExpression) {
        super();

        this.subExpression = subExpression;
    }

    execute(inputNoteSet, searchContext) {
        const subNoteSet = this.subExpression.execute(inputNoteSet, searchContext);

        return inputNoteSet.minus(subNoteSet);
    }
}

module.exports = NotExp;
