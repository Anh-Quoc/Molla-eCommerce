import {
    Controller,
    Get,
    Post,
    Body,
    Param,
    Delete,
    Request,
    Put,
} from 'node_modules/@nestjs/common';
import {ApiOperation, ApiParam, ApiResponse} from 'node_modules/@nestjs/swagger';
import {UpdateUserInputDto} from '../dtos/update-user.input.dto';
import {UserResponseDto} from '../dtos/user.response.dto';
import {plainToClass} from 'class-transformer';
import {UsersService} from '../services/users.service';
import {CustomerRegisterDto} from '../dtos/customer-register.dto';
import {Logger, UseGuards} from "@nestjs/common";
import {AuthGuard} from "../../auth/auth.guard";
import {ApiBearerAuth, ApiHeader, ApiHeaders, ApiTags} from "@nestjs/swagger";

@Controller('customer')
export class UsersController {

    private readonly logger = new Logger(UsersController.name);


    constructor(private readonly usersService: UsersService) {
    }

    // @ApiOperation({
    //   summary: 'Retrieve all users',
    //   description:
    //     'This endpoint retrieves a list of all users in the system. Each user’s details are included in the response.',
    // })
    // @ApiResponse({
    //   status: 200,
    //   description: 'Successfully retrieved all users.',
    //   type: [UserResponseDto],
    // })
    // @ApiResponse({
    //   status: 204,
    //   description: 'No content. No users found in the system.',
    // })
    // @ApiResponse({
    //   status: 500,
    //   description:
    //     'Internal server error. The users could not be retrieved due to a server issue.',
    // })
    // @Get()
    // // Get all user API
    // async findAll(): Promise<UserResponseDto[]> {
    //   const profiles = await this.usersService.findAll();

    //   return plainToClass(UserResponseDto, profiles, {
    //     excludeExtraneousValues: true,
    //     exposeUnsetFields: false,
    //   });
    // }

    @ApiOperation({
        summary: 'Retrieve a single user by ID',
        description:
            'This endpoint retrieves the details of a user specified by the given ID. Ensure the ID is valid and corresponds to an existing user.',
    })
    @ApiTags('Common')
    // @ApiParam({
    //   name: 'id',
    //   description: 'The unique identifier of the user profile to retrieve.',
    //   example: 1,
    // })
    @ApiResponse({
        status: 200,
        description: 'Successfully retrieved the user.',
        type: UserResponseDto,
    })
    @ApiResponse({
        status: 404,
        description:
            'User not found. The provided ID does not match any existing user.',
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid ID format. Ensure the ID is in the correct format.',
    })
    @ApiResponse({
        status: 500,
        description:
            'Internal server error. The user could not be retrieved due to a server issue.',
    })
    @Get('profile')
    @ApiBearerAuth() // Adds Bearer Auth for this endpoint
    @ApiHeader({
        name: 'Authorization',
        description: 'Bearer token for authentication',
        example: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInJvbGUiOjIsImlhdCI6MTcyNDE0NDU5MSwiZXhwIjoxNzI0MjMwOTkxfQ.-RA-kLjcrdrKGOkzHQgk2S1Gstl6KHiXo9TPGY2YA28',
        required: true
    })
    @ApiBearerAuth('Authorization')
    @UseGuards(AuthGuard) // Ensure AuthGuard is properly implemented
    // Find one user API
    async getCurrentUserProfile(@Request() req): Promise<UserResponseDto> {
        const profile = await this.usersService.findById(req.user_id);

        return plainToClass(UserResponseDto, profile, {
            excludeExtraneousValues: true,
            exposeUnsetFields: false,
        });
    }

    @ApiOperation({
        summary: 'Register a new Customer',
        description:
            'This endpoint allows for the registration of a new customer with the provided details. Ensure all required fields are provided and valid.',
    })
    @ApiResponse({
        status: 201,
        description: 'User successfully registered.',
        type: UserResponseDto,
    })
    @ApiResponse({
        status: 400,
        description: 'Bad request. The provided data is invalid or incomplete.',
    })
    @ApiResponse({
        status: 409,
        description:
            'Conflict. A user with the same email or username already exists.',
    })
    @ApiResponse({
        status: 500,
        description:
            'Internal server error. The user could not be registered due to a server issue.',
    })
    @Post()
    // Register user API
    async register(@Body() userResponseDto: CustomerRegisterDto): Promise<void> {
        const profile = await this.usersService.create(userResponseDto);
    }

    @ApiOperation({
        summary: 'Update an existing user profile by ID',
        description:
            'This endpoint updates the user profile specified by the given ID. Provide the updated details in the request body. Ensure the ID is valid and corresponds to an existing user.',
    })
    @ApiParam({
        name: 'id',
        description: 'The unique identifier of the user profile to update.',
        example: 1,
    })
    @ApiResponse({
        status: 200,
        description: 'User profile updated successfully.',
        type: UserResponseDto,
    })
    @ApiResponse({
        status: 400,
        description: 'Bad request. The provided data is invalid or incomplete.',
    })
    @ApiResponse({
        status: 404,
        description:
            'User not found. The provided ID does not match any existing user.',
    })
    @ApiResponse({
        status: 409,
        description:
            'Conflict. There was an issue with the update, such as conflicting data.',
    })
    @ApiResponse({
        status: 500,
        description:
            'Internal server error. The user profile could not be updated due to a server issue.',
    })
    @Put(':id')
    // Update user API
    async update(
        @Param('id') id: number,
        @Body() updateUserInputDto: UpdateUserInputDto,
    ): Promise<UserResponseDto> {
        const profile = await this.usersService.update(id, updateUserInputDto);

        return plainToClass(UserResponseDto, profile, {
            excludeExtraneousValues: true,
            exposeUnsetFields: false,
        });
    }

    @ApiOperation({
        summary: 'Delete an existing user profile by ID',
        description:
            'This endpoint deletes the user profile specified by the given ID. Ensure that the ID is valid and corresponds to an existing user. The operation will remove the user from the system.',
    })
    @ApiParam({
        name: 'id',
        description: 'The unique identifier of the user profile to delete.',
        example: 1,
    })
    @ApiResponse({
        status: 200,
        description: 'User profile deleted successfully.',
    })
    @ApiResponse({
        status: 404,
        description:
            'User not found. The provided ID does not match any existing user.',
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid ID format. Ensure the ID is in the correct format.',
    })
    @ApiResponse({
        status: 500,
        description:
            'Internal server error. The user profile could not be deleted due to a server issue.',
    })
    @Delete(':id')
    // Delete user API
    async delete(@Param('id') id: number): Promise<void> {
        return this.usersService.remove(id);
    }
}
  