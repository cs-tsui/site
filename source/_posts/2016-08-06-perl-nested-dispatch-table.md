---
layout: post
title: "Nested Dispatch Tables"
date: 2016-08-06 10:00:27 -0400
comments: true
categories: Perl 
---

The dispatch table pattern is very commonly used in Perl for mapping an action to a handler function. A simple dispatch table looks something like this.

{% codeblock lang:perl %}
my $dispatch = {
    'insert' => sub {
        # Do insert
    },
    'remove' => sub {
        # Do remove 
    }
};

$dispatch->{$action}->() if exists $dispatch->{$action};

{% endcodeblock %}

This is used in place of if/else or switches to determine which logic path to follow with the advantage of each logic path broken up into clearly separated subroutines.

###Multi-level Actions

When there are any additional levels of sub-actions possible for each action, each combination will again have to be taken care of.

{% codeblock lang:perl %}

# Nested if/else
if ($action eq 'primary_action')
{
    if    ($subaction eq 'option1') {}
    elsif ($subaction eq 'option2') {}
}
elsif ($action eq 'secondary_action')
{
    if    ($subaction eq 'option1') {}
    elsif ($subaction eq 'option2') {}
}

{% endcodeblock %}

{% codeblock lang:perl %}
# Nested dispatch table
my $dispatch = {
    'primary_action' => {
        'option1' => sub {},
        'option2' => sub {},
    },
    'secondary_action' => {
        'option1' => sub {},
        'option2' => sub {},
    }
};

$dispatch->{$action}->{$subaction}->();

{% endcodeblock %}

Using the nested display approach is slightly cleaner and more succinct than the nested if/else approach, *especially* if the code for each logic path is long or if there are many action and subaction combinations. But the advantage is small if there aren't too many actions and subaction combinations.

### Mimic Polymorphism

Suppose we are looping through a list of items (list of hashes) and we want to apply some action to each. In an object-oriented system, this would likely be a list of objects with all items implementing the same interface, allowing different behavior depending on the implementation of the interface functions.

This technique is most useful when working with existing procedural systems where you want to mimic this behaviour, and creating classes solely for a small portion of the code doesn't make much sense.

{% codeblock lang:perl %}
# Nested dispatch with multiple steps for each combination
my $dispatch = {
    'primary_action' => {
        'option1' => {
            should_skip => sub {},
            do_work     => sub {},
        },
        'option2' => {
            should_skip => sub {},
            do_work     => sub {},
        },
    },
    'secondary_action' => {
         'option1' => {
            should_skip => sub {},
            do_work     => sub {},
        },
        'option2' => {
            should_skip => sub {},
            do_work     => sub {},
        },
    }
};

for my $item in (@items) {
    my $item_prop1 = $item->{prop1};
    my $item_prop2 = $item->{prop2};
    
    # Skip this item if we don't need to work on it for now
    # to save some resources for fetching additional data
    next if $dispatch->{$action1}->{$subaction2}->{should_skip}->();

    # Fetch additional information not available in the item hash itself
    my $additional_args = fetch_data($item);

    # Do Work 
    $dispatch->{$action1}->{$subaction2}->{do_work}->($additional_args);
}

{% endcodeblock %}

### Summary
Without using a nested dispatch table, multiple if/else blocks or switches will have to be used to mimic this nested branching behavior. Using a dispatch table is a good way to avoid duplicating code. Now all the related code are consolidated in one place in a hash data structure that can easily be modified. Another advantage of this approach is the dispatch table may be created at a local scope to take advantage of closures so the handler functions can focus on a
small tasks and assume certain state variables that are only available within the local scope are availible without explicitly passing all variables as arguments.
