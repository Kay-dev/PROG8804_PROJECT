const { getTodos, createTodo, updateTodo, deleteTodo } = require('../controllers/todosController');
const { supabase } = require('../config/database');

// Mock the database module
jest.mock('../config/database', () => ({
    supabase: {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        limit: jest.fn().mockReturnThis(),
        insert: jest.fn().mockReturnThis(),
        update: jest.fn().mockReturnThis(),
    },
}));

// Tests for api: getTodos()
describe('getTodos', () => {
    let ctx;

    beforeEach(() => {
        ctx = {
            status: null,
            body: null,
        };
    });

    it('should return a list of todos', async () => {
        // Arrange
        const mockTodos = [
            { id: 1, data: 'Test todo 1', done: false },
            { id: 2, data: 'Test todo 2', done: true },
        ];
        supabase.from().select().limit.mockResolvedValue({ data: mockTodos, error: null });

        // Act
        await getTodos(ctx);

        // Assert
        expect(ctx.status).toBe(200);
        expect(ctx.body).toEqual(mockTodos);
    });

    it('should handle errors', async () => {
        // Arrange
        const mockError = new Error('Something went wrong');
        supabase.from().select().limit.mockResolvedValue({ data: null, error: mockError });

        // Act
        await getTodos(ctx);

        // Assert
        expect(ctx.status).toBe(500);
        expect(ctx.body).toEqual({ error: mockError.message });
    });

    it('should limit the number of todos returned', async () => {
        // Arrange
        const mockTodos = Array.from({ length: 10 }, (_, i) => ({ id: i + 1, data: `Test todo ${i + 1}`, done: false }));
        supabase.from().select().limit.mockResolvedValue({ data: mockTodos, error: null });

        // Act
        await getTodos(ctx);

        // Assert
        expect(ctx.status).toBe(200);
        expect(ctx.body.length).toBeLessThanOrEqual(10);
    });
});

describe('createTodo', () => {
    let ctx;

    beforeEach(() => {
        ctx = {
            status: null,
            body: null,
            request: {
                body: null,
            },
        };
    });

    it('should create a new todo', async () => {
        // Arrange
        const newTodo = { data: 'New todo' };
        const createdTodo = { id: 1, data: 'New todo', done: false };
        ctx.request.body = newTodo;
        supabase.from().insert.mockReturnValue({
            select: jest.fn().mockResolvedValue({ data: createdTodo, error: null }),
        });

        // Act
        await createTodo(ctx);

        // Assert
        expect(ctx.status).toBe(201);
        expect(ctx.body).toEqual(createdTodo);
    });

    it('should handle errors', async () => {
        // Arrange
        const newTodo = { data: 'New todo' };
        const mockError = new Error('Something went wrong');
        ctx.request.body = newTodo;
        supabase.from().insert.mockReturnValue({
            select: jest.fn().mockResolvedValue({ data: null, error: mockError }),
        });
        // Act
        await createTodo(ctx);

        // Assert
        expect(ctx.status).toBe(500);
        expect(ctx.body).toEqual({ error: mockError.message });
    });
});

describe('updateTodo', () => {
    let ctx;

    beforeEach(() => {
        ctx = {
            status: null,
            body: null,
            params: {
                id: null,
            },
            request: {
                body: null,
            },
        };
    });

    it('should update an existing todo', async () => {
        // Arrange
        const updatedTodo = { id: 1, data: 'Updated todo', done: true };
        ctx.params.id = 1;
        ctx.request.body = { data: 'Updated todo', done: true };
        supabase.from().update.mockReturnValue({
            eq: jest.fn().mockReturnThis(),
            select: jest.fn().mockResolvedValue({ data: updatedTodo, error: null }),
        });

        // Act
        await updateTodo(ctx);

        // Assert
        expect(ctx.status).toBe(200);
        expect(ctx.body).toEqual(updatedTodo);
    });

    it('should handle errors', async () => {
        // Arrange
        const mockError = new Error('Something went wrong');
        ctx.params.id = 1;
        ctx.request.body = { data: 'Updated todo', done: true };
        supabase.from().update.mockReturnValue({
            eq: jest.fn().mockReturnThis(),
            select: jest.fn().mockResolvedValue({ data: null, error: mockError }),
        });

        // Act
        await updateTodo(ctx);

        // Assert
        expect(ctx.status).toBe(500);
        expect(ctx.body).toEqual({ error: mockError.message });
    });
});